import Print
import Sequential
import Parallel
import Executor


var p = new_print("dead", 3) & new_print("beef", 4) & new_print("code", 5)
var s = new_print("hello", 1) $ new_print("world", 2)
var v = s $ p

var count = 0
proc getnext():Event =
    case count
    of 3: count = 5
    of 5: count = 4
    of 4: count = 6
    else: count += 1
    result = (device: count, status: 1, time: 1)
v.execute(getnext)
echo($v)
