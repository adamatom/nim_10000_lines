#Module vehicle
type Vehicle = ref object of RootObj # not exported interface type
    name: string #private outside of module
    mileage*: int #public member var
    color: string #private

#export a property that will set the color on any vehicle
method `color=`*(self: Vehicle, color: string) {.base.} =
    echo "manipulating color via property"
    self.color = color

method color*(self: Vehicle):string {.base.} =
    self.color

method name*(self: Vehicle):string {.base} =
    self.name

type CRV* = ref object of Vehicle # CRV implements Vehicle. Exported type
    my_other_prop: bool

method my_other_prop*(self: CRV):bool {.base.} =
    self.my_other_prop

proc new_CRV*(mileage: int, color: string):CRV =
    CRV(name:"CRV", mileage:mileage, color:color, my_other_prop:false)

method `color=`*(self: CRV, color:string) = #check out dynamic dispatch
    echo "CRV is now color " & color
    self.color = color




