## Module 10: Understanding Functions, Expressions, and Loops


#### Functions


Lower:
```
lower("TFStoragesta")
```

Replace:
```
replace("Luke likes CloudSkills", "likes", "loves")
```

```
replace("/subscriptions/f8c37571-4325-4a97-977b-7a216e64bae3/resourceGroups/rg-remotestatetfc", "/[0-9A-Fa-f]{8}-(?:[0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}/", "c1c37531-2355-4a57-947b-4e236e64bae3")
```

Min and Max:
```
max(32,64,99)
```
```
min (32,128,1024)
```
Join:
```
join(", ", ["vnet1", "vnet2", "vnet3"])

join("", ["ApplicationName", "-rg"])
```


Split:
```
split("_","Standard_LRS")
```

Element:
```
element(split("_","Standard_LRS"), 0)
```

Coalesce:
```
coalesce("40", "50", "20")
```
```
coalesce( "", "50", "20")
```

Length:
```
length(["32GB", "64GB"])
```

Setproduct:
```
setproduct(["development", "staging", "production"], ["EastUS", "WestUS"])
```
