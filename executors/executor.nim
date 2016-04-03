# Executors support this protocol:
#
# resources: an accessor that returns the set of resources used by this executor.
# This is used by parallel to route events to one of its lanes.
#
# start( done_callback): starts the executor, returns immediately.
# The executor must call done_callback to signal it is complete.
#
# handle_event: called repeatedly after start() and before done_callback(),
# to tell the executor about events that it should handle.
#
# serialize: returns a string representing the executor for logging and debugging.
import future
type Executor* = ref object of RootObj
    done: bool

type Event* = tuple[device, status, time: int]
type DoneCallback* = (() -> void) # is a function that takes nothing and returns nothing, depends on closures
type NextEventSource* = (() -> Event) # is a function that takes nothing and returns an event tuple


#interface methods
method start*(self: Executor, done_fn: DoneCallback) {.base.} = discard
method handle_event*(self: Executor, event: Event) {.base.} = discard
method resources*(self: Executor): seq[int] {.base.} = discard
method serialize*(self: Executor, indent: string): string {.base.} = discard

#not expected to be overridden, but go nuts if it helps
proc execute*[T](self: T, get_next_event: NextEventSource) =
    self.start( ()=>(self.done=true) )
    while not self.done:
        self.handle_event(get_next_event())








