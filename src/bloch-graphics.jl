using Luxor, Thebes

function drawArrow(p2)
    pin(Point3D(0, 0, 0), p2, 
        gfunction = (p3p, p2p) -> Thebes.arrow(first(p2p), last(p2p), linewidth = 3.0))
end

function drawPoly(points)
    pin(points, gfunction = (p3, p2) -> poly(p2, close=true, :fill))
end

function drawSphere(r)
    setcolor(0,0,0, 0.05)
    setline(0.5)
    drawPoly([Point3D(r*cos(θi), r*sin(θi), 0) for θi in 0:π/50:2π])
    for ϕi in 0:π/2:2π
        drawPoly([Point3D(r*sin(θi)cos(ϕi), r*sin(θi)sin(ϕi), r*cos(θi)) for θi in 0:π/50:2π])
    end

    setcolor("grey90")
    axes3D()
end

function drawBlochVector(θ, ϕ, r)
    ϕ = (θ == 0) ? 0 : ϕ
    state = Point3D(r*sin(θ)cos(ϕ), r*sin(θ)sin(ϕ), r*cos(θ))

    sethue("black")
    setline(4)
    drawArrow(state)

    setcolor("white")
    setline(2)
    pin(state, gfunction = (p3p, p2p) -> circle(p2p, 3, :stroke))
end

function drawBlochSphere(θ, ϕ; r = 100, view_angle=π/32, name="bloch-sphere.png")
    Drawing(250, 250, name)
    origin()

    eyepoint(rotateZ(Point3D(200, 50, 60), view_angle))
    perspective(0)

    drawSphere(r)
    drawBlochVector(θ, ϕ, r)

    finish()
    preview()
end