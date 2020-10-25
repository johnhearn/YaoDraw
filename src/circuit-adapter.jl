using Yao

function draw(chain::ChainBlock{n}; name="circuit.png", width=600) where n
    draw_circuit(n, name, width)
    draw(0, chain)
    finish()
    preview()
end

function draw(xoffset, chain::ChainBlock{n}) where n
    @debug chain
    xoff = 0 # offset of current column
    width = 0 # width of current column
    occupied = Set() # set of occupied location in current column
    for block in chain.blocks
        occupies = Set(occupied_locs(block))
        if (isdisjoint(occupies, occupied))
            # No conflict so just draw in the same column
            width = max(width, draw(xoffset + xoff, block))
        else
            # Overlaps with existing gate so move to next column
            xoff += width
            occupied = occupies
            width = draw(xoffset + xoff, block)
        end
        union!(occupied, occupies)
    end
    xoff + width # width of whole component
end

function name(const_gate::ConstantGate{1})
    string(string(const_gate)[1])
end

function name(negated_const_gate::Scale{Val{α},1,<:ConstantGate{1}}) where α
    ((α==-1) ? "-" : "$α") * name(negated_const_gate.content)
end

function name(shift_gate::ShiftGate{<:Real})
    "R"
end

function draw(xoffset, row, const_gate::ConstantGate{1})
    @debug const_gate
    draw_gate(name(const_gate), xoffset, row)
    50
end

function draw(xoffset, put_block::PutBlock{n,k,G}) where {n,k,G}
    @debug n,k,G,put_block.locs
    for i in put_block.locs # not sure about this
        draw(xoffset, i, put_block.content)
    end
    50
end

function draw(xoffset, repeated_block::RepeatedBlock{n,k,G}) where {n,k,G}
    @debug n,k,G,repeated_block.locs
    for i in repeated_block.locs
        draw(xoffset, i, repeated_block.content)
    end
    50
end

function draw(xoffset, control_block::ControlBlock{n,G,k,1}) where {n,G,k}
    @debug n,k,G,control_block.ctrl_locs,control_block.ctrl_config
    draw_control_gate(name(control_block.content), xoffset, control_block.locs[1], control_block.ctrl_locs, control_block.ctrl_config)
    50
end

function draw(xoffset, matrix_block::GeneralMatrixBlock{M, n, MT}) where {M,n,MT}
    @debug matrix_block
    draw_oracle("Uf", xoffset, 1, n)
    60
end
