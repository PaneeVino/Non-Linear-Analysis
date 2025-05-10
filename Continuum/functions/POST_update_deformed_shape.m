function POST = POST_update_deformed_shape( POST, MODEL, SOL )

nincr = SOL.nincr;
POST.STEP(nincr).X  = MODEL.X;
POST.STEP(nincr).Y  = MODEL.Y;
if MODEL.dim == 3
    POST.STEP(nincr).Z = MODEL.Z;
end
POST.STEP(nincr).x  = MODEL.x;
POST.STEP(nincr).y  = MODEL.y;
if MODEL.dim == 3
    POST.STEP(nincr).z = MODEL.z;
end
POST.STEP(nincr).Ux = MODEL.Ux;
POST.STEP(nincr).Uy = MODEL.Uy;
POST.STEP(nincr).U_nodes = MODEL.U_nodes;
if MODEL.dim == 3
    POST.STEP(nincr).Uz = MODEL.Uz;
end

for k = 1 : MODEL.nels
    % Get the element nodes
    Nodes = MODEL.elements(k, :);

    % Calculate the total displacement (magnitude) for each node in the element
    for kk = 1 : length(Nodes)
        switch MODEL.dim
            case 2
                        POST.STEP(nincr).U_tot(k, kk) = ... 
            sqrt(POST.STEP(nincr).Ux(k, kk)^2 + POST.STEP(nincr).Uy(k, kk)^2);  % Total displacement (magnitude)
            case 3
                                        POST.STEP(nincr).U_tot(k, kk) = ... 
            sqrt(POST.STEP(nincr).Ux(k, kk)^2 + POST.STEP(nincr).Uy(k, kk)^2 + POST.STEP(nincr).Uz(k, kk)^2);  % Total displacement (magnitude)
        end
    end
end

end