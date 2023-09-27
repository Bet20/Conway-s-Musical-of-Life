package main

import tm "core:time"
import ray "vendor:raylib"

WINDOW_SIZE :: 1024
CELL_SIZE :: 1024/32

Game :: struct {
    tick_rate: tm.Duration,
    tick_last: tm.Time,
    colors: []ray.Color,
    width: i32,
    height: i32
}

Window :: struct {
    title: cstring,
    width: i32,
    height: i32,
    fps: i32,
    control_flags: ray.ConfigFlags
}

World :: struct {
    width: i32,
    height: i32,
    alive: []u8
}

render_world :: proc(world: ^World, colors: []ray.Color) {
    x, y : i32
    for y = 0; y < world.height; y += 1 {
        for x = 0; x < world.width; x += 1 {
            rect := ray.Rectangle{f32(x*CELL_SIZE), f32(y*CELL_SIZE), f32(CELL_SIZE), f32(CELL_SIZE)}
            curr_color := colors[world.alive[y*world.width+x]]
            ray.DrawRectangleRec(rect, curr_color)
        }
    }
}

main :: proc() {
    window := Window{"Life", WINDOW_SIZE, WINDOW_SIZE, 60, ray.ConfigFlags{.WINDOW_UNDECORATED}}

    game := Game{
        tick_rate = 300 * tm.Millisecond,
        tick_last = tm.now(),
        colors = []ray.Color{ray.BLACK, ray.YELLOW},
        width = 32,
        height = 32,
    }

    world := World{game.width, game.height, make([]u8, game.width * game.height)}
    for _, i in world.alive {
        if i%5 == 0 {
        world.alive[i] = 1
       } 
    }

    defer delete(world.alive)

    ray.InitWindow(window.width, window.height, window.title)
    ray.SetWindowState( window.control_flags )
    ray.SetTargetFPS(window.fps)
    for !ray.WindowShouldClose() {
    
        ray.BeginDrawing()
        render_world(&world, game.colors)     
        ray.ClearBackground(ray.BLUE)
        ray.EndDrawing()
    }
}

