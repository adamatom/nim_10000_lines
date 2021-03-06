import future
import Executor

type Sequential* = ref object of Executor
    steps: seq[Executor]
    done_fn: DoneCallback
    step: int
    started: bool

proc new_sequential*(steps: seq[Executor]): Sequential =
    Sequential(started: false, steps: steps, step: 0)

proc next_step(self: Sequential) =
    self.step += 1
    if self.step >= len(self.steps):
        self.done_fn()
    else:
        self.steps[self.step].start(()=>(self.next_step()))

method start*(self: Sequential, done_fn: DoneCallback) =
    self.step = 0
    self.done_fn = done_fn
    self.started = true
    assert(len(self.steps) > 0)
    self.steps[self.step].start( ()=>(self.next_step()) )

method handle_event*(self: Sequential, event: Event) =
    self.steps[self.step].handle_event(event)

method resources*(self: Sequential): seq[int] =
    var resources: seq[int]
    for ex in self.steps:
        resources.add ex.resources()

method serialize*(self: Sequential, indent: string): string =
    result = indent & "sequential{\n"
    for step in self.steps:
        result &= step.serialize(indent & "    ") & ",\n"
    result &= indent & "}"

proc `$`*(p: Sequential):string =
    return p.serialize("")

proc `$`*(e1,e2: Executor): Sequential =
    var es: seq[Executor]
    es = @[]
    es.add(e1)
    es.add(e2)
    return new_sequential(steps=es)

proc `$`*(s: Sequential, e: Executor): Executor =
    assert(not s.started)
    s.steps.add(e)
    return s
