import future
import tables
import Executor

type Parallel* = ref object of Executor
    lanes: seq[Executor]
    resource_to_lane: Table[int, Executor]
    oustanding_lanes: int
    done_fn: DoneCallback

proc new_parallel*(lanes: seq[Executor]): Parallel =
    var res_map = initTable[int, Executor](len(lanes))
    for lane_id,lane in lanes:
        var resources = lane.resources()
        for resource in resources:
            assert(not res_map.contains(resource))
            res_map.add(resource, lane)
    return Parallel(lanes: lanes, resource_to_lane: res_map)

proc possibly_done(self: Parallel) =
    self.oustanding_lanes -= 1
    if self.oustanding_lanes == 0:
        self.done_fn()

method start*(self: Parallel, done_fn: DoneCallback) =
    self.done_fn = done_fn
    self.oustanding_lanes = len(self.lanes)
    # parallel starts all lanes and waits for them all to report in
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
    return indent & "parallel{}"

