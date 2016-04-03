import vehicles as v

var c = v.new_CRV(mileage=100, color="red")
echo c.name #immutable, accessible via getter

echo c.mileage #mutable via public member var
c.mileage = 150000
echo c.mileage

echo(c.color) #mutable via property
c.color = "green"
echo c.color

echo c.my_other_prop #immutable, accessible via getter

