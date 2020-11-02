# Basic-Liquid-Physics-2D
Simple water simulation with water distortion for 2d games. Uses the built-in pipeline for shaders.

It uses a RenderTexture and a Camera only rendering the water layer which then applies
a blur effect. The resulting texture is rendered onto a quad placed infront of the
camera.
The quad uses a cutout shader which applies a distortion effect from a normal map.

To use this use the Water Camera Prefab and a Water Emitter to spawn water.

Water is a gameobject with a simple circle collider and a rigidbody.
