using Luxor

const row_height = 50
const margin_left = 10
const margin_top = 20
const margin_right = 10
const margin_bottom = 10

function draw_circuit(num_bits, name, width)
    Drawing(width, margin_top+num_bits*row_height+margin_bottom, name)
    origin(margin_left, margin_top)
    setopacity(1.0)
    background("white")
    setcolor("black")

    fontsize(25)
    setline(1)
    
    for i in 1:num_bits
        draw_ket(i)
    end

    draw_wires(0, n)
end

yoffset(row) = 15+row_height * (row-1)

function draw_ket(row)
    y = yoffset(row)
    setcolor("black")
    line(Point(20, y-15), Point(20, y+15), :stroke)
    fontface("Times")
    Luxor.text("0", 24, 8+y, halign=:left, valign=:center)
    line(Point(36, y-15), Point(42, y), :stroke)
    line(Point(42, y), Point(36, y+15), :stroke)
end

function draw_wires(x, num_bits)
    xm = 50
    for row in 1:num_bits
        y = yoffset(row)
        setcolor("black")
        line(Point(xm+x, y), Point(xm+x+50, y), :stroke)
    end
end

function draw_gate(gate, x, row)
    xm = 70
    y = yoffset(row)-15
    setcolor("white")
    rect(xm+x, 1+y, 30, 30, :fill)
    setcolor("black")
    rect(xm+x, 1+y, 30, 30, :stroke)
    fontface("Times Italic")
    Luxor.text(gate, xm+x+15, 24+y, halign=:center, valign=:center)
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
    setcolor("black")
    rect(70+xoffset, 1+yoffset, 40, yheight+30, :stroke)
    fontface("Times Italic")
    Luxor.text(gate, 88+xoffset, 24+yoffset+yheight/2, halign=:center, valign=:center)
end

