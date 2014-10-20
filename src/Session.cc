/* -*- Mode: C++; tab-width: 8; c-basic-offset: 2; indent-tabs-mode: nil; -*- */

//#define DEBUGTAG "Session"

#include "Session.h"

#include <syscall.h>
#include <sys/prctl.h>

#include <algorithm>

#include "log.h"
#include "task.h"
#include "util.h"

using namespace rr;
using namespace std;

Session::Session() : tracees_consistent(false) {
  LOG(debug) << "Session " << this << " created";
}

Session::~Session() {
  kill_all_tasks();
  LOG(debug) << "Session " << this << " destroyed";
}

void Session::after_exec() {
  if (tracees_consistent) {
    return;
  }
  tracees_consistent = true;
  // Reset ticks for all Tasks (there should only be one).
  for (auto task = tasks().begin(); task != tasks().end(); ++task) {
    task->second->flush_inconsistent_state();
  }
}

AddressSpace::shr_ptr Session::create_vm(Task* t, const std::string& exe) {
  AddressSpace::shr_ptr as(new AddressSpace(t, exe, *this));
  as->insert_task(t);
  sas.insert(as.get());
  return as;
}

AddressSpace::shr_ptr Session::clone(AddressSpace::shr_ptr vm) {
  AddressSpace::shr_ptr as(new AddressSpace(*vm));
  as->session = this;
  sas.insert(as.get());
  return as;
}

Task* Session::clone(Task* p, int flags, remote_ptr<void> stack,
                     remote_ptr<void> tls, remote_ptr<int> cleartid_addr,
                     pid_t new_tid, pid_t new_rec_tid) {
  Task* c = p->clone(flags, stack, tls, cleartid_addr, new_tid, new_rec_tid);
  on_create(c);
  return c;
}

TaskGroup::shr_ptr Session::create_tg(Task* t) {
  TaskGroup::shr_ptr tg(new TaskGroup(t->rec_tid, t->tid));
  tg->insert_task(t);
  return tg;
}

Task* Session::find_task(pid_t rec_tid) {
  auto it = tasks().find(rec_tid);
  return tasks().end() != it ? it->second : nullptr;
}

void Session::kill_all_tasks() {
  while (!task_map.empty()) {
    Task* t = task_map.rbegin()->second;
    LOG(debug) << "Killing " << t->tid << "(" << t << ")";
    t->kill();
    delete t;
  }
}

void Session::on_destroy(AddressSpace* vm) {
  assert(vm->task_set().size() == 0);
  assert(sas.end() != sas.find(vm));
  sas.erase(vm);
}

void Session::on_destroy(Task* t) {
  task_map.erase(t->rec_tid);
}

void Session::on_create(Task* t) {
  task_map[t->rec_tid] = t;
}
