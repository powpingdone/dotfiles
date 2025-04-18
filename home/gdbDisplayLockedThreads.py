#! /usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright © 2017 Damian Ziobro <damian@xmementoit.com>

import gdb

class Thread():
    def __init__(self):
        self.frames = []
        self.waitOnThread = None
        self.threadId = None

    def __getitem__(self):
        return self.waitOnThread
        

class DisplayLockedThreads(gdb.Command):
    def __init__(self):
        super (DisplayLockedThreads, self).__init__("blocked", gdb.COMMAND_SUPPORT,gdb.COMPLETE_NONE,True)
        print (self.__doc__)

    def invoke(self, arg, from_tty):
        print ("\n********************************************************************************")
        print ("Displaying blocking threads using 'blocked' command")
        threads = {}
        for process in gdb.inferiors():
            for thread in process.threads():
                trd = Thread()
                trd.threadId = thread.ptid[1] #[1] - threadId; [0] - process pid
                #print ("Thread: {0}".format(threads[-1].threadId))
                thread.switch()
                frame = gdb.selected_frame()
                while frame:
                    frame.select()
                    name = frame.name()
                    if name is None:
                        name = "??"
                    if "pthread_mutex_lock" in name:
                        trd.waitOnThread = int(gdb.execute("print mutex.__data.__owner", to_string=True).split()[2])
                        #print(threads[-1].waitOnThread)
                    trd.frames.append(name)
                    frame = frame.older()
                threads[trd.threadId] = trd

        for (tid,thread) in threads.items():
            if thread.waitOnThread:
                if thread.waitOnThread in threads and threads[thread.waitOnThread].waitOnThread == thread.threadId:
                    deadlockedText = "AND DEADLOCKED"
                else:
                    deadlockedText = ""
                print ("Thread: {0} waits for thread: {1} {2}".format(thread.threadId, thread.waitOnThread, deadlockedText))
        print ("********************************************************************************")

DisplayLockedThreads()
