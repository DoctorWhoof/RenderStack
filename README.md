This Repo is obsolete! It was created before Mojo had batching, and it runs much slower that just "pure" Monkey2+Mojo as far as I can tell!
------------------------------------------------------------------------------------------------------------------------------------------------

# RenderStack
A very basic Render Stack that provides automatic batching and depth sorting for the Monkey 2 Programming Language.

I created this mostly because I was getting low performance on integrated Intel GPUs. Batching didn't seem make a huge difference on my AMD discreet GPU, but it definitely helped a lot on the Intel GPUs.

Switching depth sorting on can have a big performance hit if you have too many items (thousands).

