# RenderStack
A very basic Render Stack that provides automatic batching and depth sorting for the Monkey 2 Programming Language.

I created this mostly because I was getting low performance on integrated Intel GPUs. Bacthing didn't seem make a huge difference on my AMD discreet GPU, but it definitely helped a lot on the Intel GPUs.

Switching sorting on can have a big performance hit if you have too many items (thousands).

