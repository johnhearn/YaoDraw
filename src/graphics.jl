using Luxor

const row_height = 50
const margin_left = 10
const margin_top = 20
const margin_right = 10
const margin_bottom = 20

function draw_circuit(num_bits; name="circuit.png")
    Drawing(600, margin_top+num_bits*row_height+margin_bottom, name)
    origin(margin_left, margin_top)
    setopacity(1.0)
    background("white")
    setcolor("black")

    fontsize(25)
    
    for i in 1:num_bits
        draw_qubit(i)
    end
end

function draw_qubit(row)
    setline(1)
    setcolor("black")
    voffset = 15+row_height * (row-1)
    @show voffset
    line(Point(20, voffset-15), Point(20, voffset+15), :stroke)
    fontface("Times")
    text("0", 24, 8+voffset, halign=:left, valign=:center)
    line(Point(36, voffset-15), Point(42, voffset), :stroke)
    line(Point(42, voffset), Point(36, voffset+15), :stroke)
    line(Point(50, voffset), Point(600, voffset), :stroke)
end

function draw_gate(gate, xoffset, row)
    setcolor("white")
    yoffset = (row-1) * row_height
    rect(70+xoffset, 1+yoffset, 30, 30, :fill)
    setline(1)
    setcolor("black")
    rect(70+xoffset, 1+yoffset, 30, 30, :stroke)
    fontface("Times Italic")
    text(gate, 85+xoffset, 24+yoffset, halign=:center, valign=:center)
end

function draw_control_gate(gate, xoffset, row, control_locs, control_config)
    yoffset = 15+(row-1) * row_height
    for cl in zip(control_locs, control_config)
        ycontrol = 15+(cl[1]-1) * row_height
        c = Point(85+xoffset, ycontrol)
        setcolor("black")
        line(c, Point(85+xoffset, yoffset), :stroke)
        circle(c, 4, :stroke)
        setcolor(cl[2] == 1 ? "black" : "white")
        circle(c, 4, :fill)
    end
    if gate == "X"
        setcolor("white")
        c = Point(85+xoffset, yoffset)
        circle(c, 10, :fill)
        setcolor("black")
        circle(c, 10, :stroke)
        line(Point(85+xoffset, yoffset-10), Point(85+xoffset, yoffset+10), :stroke)
        line(Point(85+xoffset-10, yoffset), Point(85+xoffset+10, yoffset), :stroke)
    else
        draw_gate(gate, xoffset, row)
    end
end

function draw_oracle(gate, xoffset, row, height)
    setcolor("white")
    yoffset = (row-1) * row_height
    yheight = (height-1) * row_height
    rect(70+xoffset, 1+yoffset, 40, yheight+30, :fill)
    setline(1)
    setcolor("black")
    rect(70+xoffset, 1+yoffset, 40, yheight+30, :stroke)
    fontface("Times Italic")
    text(gate, 88+xoffset, 24+yoffset+yheight/2, halign=:center, valign=:center)
end

