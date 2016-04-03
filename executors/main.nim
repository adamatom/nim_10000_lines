import Print
import Sequential
import Parallel
import Executor

var seq_arr: seq[Executor]
var par_arr: seq[Executor]
seq_arr = @[]
par_arr = @[]

seq_arr.add( new_print("hello", 1) )
seq_arr.add( new_print("world", 2) )

par_arr.add( new_print("dead", 3) )
par_arr.add( new_print("beef", 4) )

var p = new_parallel(lanes=par_arr)
seq_arr.add(p)
var v = new_sequential(steps=seq_arr)

var count = 0
proc getnext():Event =
    count += 1
    result = (device: count, status: 1, time: 1)
v.execute(getnext)
