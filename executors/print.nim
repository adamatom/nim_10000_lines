import future
import Executor

type Print* = ref object of Executor
    message: string
    resource: int
    # having a proc member function in a subclass causes a warning that I dont understand.
    # However, it looks like an open bug: https://github.com/nim-lang/Nim/issues/3074
    done_fn: DoneCallback

proc new_print*(message: string, resource: int): Print =
    Print(message: message, resource: resource)

method start*(self: Print, done_fn: DoneCallback) =
    self.done_fn = done_fn

method handle_event*(self: Print, event: Event) =
    assert( event.device == self.resource )
    echo self.message & " " & $event
    self.done_fn()

method resources*(self: Print): seq[int] =
    return @[self.resource]

method serialize*(self: Print, indent: string): string =
    return indent & "Print{" & self.message & "}"

