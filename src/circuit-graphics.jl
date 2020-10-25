using Luxor

const row_height = 50
const margin_left = 10
const margin_top = 20
const margin_right = 10
const margin_bottom = 10
const xm = 60 # gate x-offset

function draw_circuit(num_bits, name, width)
    Drawing(width, margin_top+num_bits*row_height+margin_bottom, name)
    origin(margin_left, margin_top)
    setopacity(1.0)
    background("white")
    setcolor("black")

    fontface("Times New Roman Italic")
    fontsize(25)
    setline(1)
    
    for i in 1:num_bits
        draw_ket(i)
    end

    draw_wires(0, num_bits)
end

yoffset(row) = 15+row_height * (row-1)

function draw_ket(row)
    y = yoffset(row)
    setcolor("black")
    line(Point(20, y-15), Point(20, y+15), :stroke)
    gsave()
    fontface("Times New Roman")
    Luxor.text("0", 24, 8+y, halign=:left, valign=:center)
    grestore()
    line(Point(36, y-15), Point(42, y), :stroke)
    line(Point(42, y), Point(36, y+15), :stroke)
end

function draw_wires(x, num_bits)
    for row in 1:num_bits
        y = yoffset(row)
        setcolor("black")
        line(Point(xm+x-10, y), Point(xm+x+40, y), :stroke)
    end
end

function draw_gate(name::String, x, row)
    y = yoffset(row)-15
    _gate_box(x, y)
    Luxor.text(name, xm+x+15, 24+y, halign=:center, valign=:center)
end

function draw_gate(name::Tuple{Char,Char}, x, row)
    y = yoffset(row)-15
    _gate_box(x, y)
    Luxor.text(string(first(name)), xm+x+12, 24+y, halign=:center, valign=:center)
    gsave()
    fontsize(15)
    Luxor.text(string(last(name)), xm+x+23, 26+y, halign=:center, valign=:center)
    grestore()
end

function _gate_box(x, y)
    setcolor("white")
    rect(xm+x, 1+y, 30, 30, :fill)
    setcolor("black")
    rect(xm+x, 1+y, 30, 30, :stroke)
end

function draw_control_gate(gate, x, row, control_locs, control_config)
    y = yoffset(row)
    for cl in zip(control_locs, control_config)
        ycontrol = yoffset(cl[1])
        c = Point(xm+x+15, ycontrol)
        setcolor("black")
        line(c, Point(xm+x+15, y), :stroke)
        circle(c, 4, :stroke)
        setcolor(cl[2] == 1 ? "black" : "white")
        circle(c, 4, :fill)
    end
    if gate == "X"
        setcolor("white")
        c = Point(xm+x+15, y)
        circle(c, 10, :fill)
        setcolor("black")
        circle(c, 10, :stroke)
        line(Point(xm+x+15, y-10), Point(xm+x+15, y+10), :stroke)
        line(Point(xm+x+5, y), Point(xm+x+25, y), :stroke)
    else
        draw_gate(gate, x, row)
    end
end

function draw_oracle(gate, xoffset, row, height)
    setcolor("white")
    yoffset = (row-1) * row_height
    yheight = (height-1) * row_height
    rect(xm+xoffset, 1+yoffset, 40, yheight+30, :fill)
    setcolor("black")
    rect(xm+xoffset, 1+yoffset, 40, yheight+30, :stroke)
    Luxor.text(gate, xm+xoffset+18, 24+yoffset+yheight/2, halign=:center, valign=:center)
end

