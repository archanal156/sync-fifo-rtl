# Synchronous FIFO Controller — RTL Design
 
A fully synthesisable **8-bit × 8-deep Synchronous FIFO Controller** designed in Verilog HDL.
 
---
 
## Design Specifications
 
| Parameter      | Value              |
|----------------|--------------------|
| Data width     | 8 bits             |
| FIFO depth     | 8 locations        |
| Pointer width  | 3 bits             |
| Reset          | Synchronous, active-high |
| Full flag      | Combinational      |
| Empty flag     | Combinational      |
| Latches        | None               |
| RTL style      | Synthesisable      |
 
---
 
## Port Description
 
| Port       | Direction | Width | Description              |
|------------|-----------|-------|--------------------------|
| `clk`      | Input     | 1     | System clock             |
| `rst`      | Input     | 1     | Synchronous reset (high) |
| `wr_en`    | Input     | 1     | Write enable             |
| `r_en`     | Input     | 1     | Read enable              |
| `data_in`  | Input     | 8     | Write data               |
| `data_out` | Output    | 8     | Read data                |
| `full`     | Output    | 1     | FIFO full flag           |
| `empty`    | Output    | 1     | FIFO empty flag          |
 
---
 
## Block Diagram
 
```
         ┌──────────────────────────────────────┐
data_in ─►                                      ├─► data_out
  wr_en ─►       8 × 8-bit Memory Array         │
   r_en ─►    (Circular buffer, ptr-based)      ├─► full
    clk ─►                                      ├─► empty
    rst ─►   wr_ptr [2:0] ──► [0..7] ◄── rd_ptr │
         └──────────────────────────────────────┘
```
 
---
 
## Operation Table
 
| `wr_en` | `r_en` | `full` | `empty` | Operation                        |
|---------|--------|--------|---------|----------------------------------|
| 1       | 0      | 0      | X       | Write `data_in` → FIFO           |
| 0       | 1      | X      | 0       | Read FIFO → `data_out`           |
| 1       | 1      | 0      | 0       | Simultaneous read + write        |
| 1       | 0      | 1      | X       | Write ignored (overflow protect) |
| 0       | 1      | X      | 1       | Read ignored (underflow protect) |
| X       | X      | X      | X       | `rst=1`: pointers & output reset |
