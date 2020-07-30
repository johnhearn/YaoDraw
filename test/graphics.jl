@draw begin
    draw_circuit(3)
    for i in 1:3
        draw_gate("H", 0, i)
        draw_control_gate("-Z", 45*1, 3, [2], [0])
        draw_control_gate("X", 45*2, 3, [2], [0])
        draw_control_gate("X", 45*3, 3, [1,2], [1,0])
        draw_oracle("Uf", 45*4, 2, 2)
    end

    finish()
    preview()
end