import future
import tables
import Executor

type Parallel* = ref object of Executor
    lanes: seq[Executor]
    resource_to_lane: Table[int, Executor]
    oustanding_lanes: int
    started: bool
    done_fn: DoneCallback

proc new_parallel*(lanes: seq[Executor]): Parallel =
    return Parallel(started: false, lanes: lanes)

proc possibly_done(self: Parallel) =
    self.oustanding_lanes -= 1
    if self.oustanding_lanes == 0:
        self.done_fn()

method start*(self: Parallel, done_fn: DoneCallback) =
    self.done_fn = done_fn
    self.oustanding_lanes = len(self.lanes)
    self.resource_to_lane = initTable[int, Executor](self.oustanding_lanes)
    for lane_id,lane in self.lanes:
        let resources = lane.resources()
        for resource in resources:
            assert(not self.resource_to_lane.contains(resource))
            self.resource_to_lane.add(resource, lane)
    # parallel starts all lanes and waits for them all to report in
    self.started = true
    for lane in self.lanes:
        lane.start( ()=>(self.possibly_done()) )

method handle_event*(self: Parallel, event: Event) =
    assert(self.resource_to_lane.contains(event.device))
    self.resource_to_lane[event.device].handle_event(event)

method resources*(self: Parallel): seq[int] =
    var resources: seq[int]
    for lane in self.lanes:
        resources.add(resources)

method serialize*(self: Parallel, indent: string): string =
    result = indent & "parallel{\n"
    for lane in self.lanes:
        result &= lane.serialize(indent & "    ") & ",\n"
    result &= indent & "}"

proc `$`*(p: Parallel):string =
    return p.serialize("")

proc `&`*(e1, e2: Executor): Parallel =
    var es: seq[Executor]
    es = @[]
    es.add(e1)
    es.add(e2)
    return new_parallel(lanes=es)

proc `&`*(p: Parallel, e: Executor): Parallel =
    assert(not p.started)
    p.lanes.add(e)
    return p
