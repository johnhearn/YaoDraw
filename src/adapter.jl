using Yao

function draw(chain::ChainBlock{n}) where n
    draw_circuit(n)
    draw(0, chain)
    finish()
    preview()
end

function draw(xoffset, chain::ChainBlock{n}) where n
    @show chain
    xoff = xoffset
    for block in chain.blocks
        @show xoffset, xoff
        xoff = draw(xoff, block)
    end
    xoff
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

function name(matrix_block::GeneralMatrixBlock{1,1,Complex{Float64},Array{Complex{Float64},2}})
    "√X"
end

function draw(xoffset, row, const_gate::ConstantGate{1})
    @show const_gate
    draw_gate(name(const_gate), xoffset, row)
    xoffset + 50
end

function draw(xoffset, put_block::PutBlock{n,k,G}) where {n,k,G}
    @show n,k,G,put_block.locs
    for i in put_block.locs # not sure about this
        draw(xoffset, i, put_block.content)
    end
    xoffset + 50
end

function draw(xoffset, repeated_block::RepeatedBlock{n,k,G}) where {n,k,G}
    @show n,k,G,repeated_block.locs
    for i in repeated_block.locs
        draw(xoffset, i, repeated_block.content)
    end
    xoffset + 50
end

function draw(xoffset, control_block::ControlBlock{n,G,k,1}) where {n,G,k}
    @show n,k,G,control_block.ctrl_locs,control_block.ctrl_config
    draw_control_gate(name(control_block.content), xoffset, control_block.locs[1], control_block.ctrl_locs, control_block.ctrl_config)
    xoffset + 50
end

function draw(xoffset, matrix_block::GeneralMatrixBlock{M, n, MT}) where {M,n,MT}
    @show matrix_block
    draw_oracle("Uf", xoffset, 1, n)
    xoffset + 60
end
