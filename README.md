# <img src="https://github.com/KoBeWi/Godot-Prefab/blob/master/Media/Icon.png" width="64" height="64"> Godot Prefab

Custom class for Godot that extends PackedScene with ability to pack a node recursively and then auto-free it.

## But why?

Imagine you have a scene like this:

![](https://github.com/KoBeWi/Godot-Prefab/blob/master/Media/ReadmeExample.png)

You have some container with another container that has a few nodes. You want a few copies of the Slot node. Normally you'd just save it as a separate scene, BUT! this is the only place where you will use it and it's just 3 nodes. Totally not worth it to create just another file, which you will have to put somewhere. Such a hassle. If you think otherwise, you could as well stop reading now.

What can be done about it? There are a couple of solutions. The simplest one is just duplicating the Slot node. Something like:
```GDScript
for i in 10:
    var slot = $Slot.duplicate()
    add_child(slot)
```
There! You now have 10 slots. No wait, it's 11 slots. Also if you want to remove some of them, you have to make sure you don't touch your original Slot, in case you want to make more of them. Also you can't really modify it, because it will break new copies.

So let's be a bit more smart.
```GDScript
onready var slot = $Slot

func _ready():
    remove_child(slot)

    for i in 10:
        add_child(slot.duplicate())
```
Now you don't have to worry about your original slot breaking, because it's never actually on the scene. You can create as many copies as you want and modify them freely. There's one catch though. You have to make sure that your `slot` variable is freed, otherwise it will leak. Another thing is that all your node copies will share their sub-resources (which is not always a problem, but still).

A slightly more elegant and safe solution is using PackedScene. You can pack the node and then instance as much as you want, without worrying about leaks etc. The problem is that `PackedScene.pack()` requires you to set the owner of all children of the node you want to pack. So your code becomes something like:
```GDScript
var slot: PackedScene

func _ready():
    for child in $Slot.get_children():
        child.owner = $Slot

    slot = PackedScene.new()
    slot.pack($Slot)
    $Slot.free() # The original node is not needed, so yeet it.

    for i in 10:
        add_child(slot.instance())
```
It became lengthy though, it would be nice to put it into some method probably.

Luckily, this is exactly what Prefab does:
```GDScript
var slot: Prefab

func _ready():
    slot = Prefab.create($Slot)

    for i in 10:
        add_child(slot.instance())
```
The second, optional, argument of `create()` makes it use `queue_free()` instead of `free()` (sometimes it's required).

Note that Prefab basically being a PackedScene means that you can save it to a file. It's not the intended usage though.

btw did you know that this plugin's README is longer than the source code? Might be not worth it creating whole repo for something so trivial, but it was useful for me, so it's probably acceptable, idk.

___
You can find all my addons on my [profile page](https://github.com/KoBeWi).

<a href='https://ko-fi.com/W7W7AD4W4' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
