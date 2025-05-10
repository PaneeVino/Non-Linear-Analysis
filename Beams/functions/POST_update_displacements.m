function POST = POST_update_displacements( POST, MODEL, SOL )

nincr = SOL.nincr;

for k = 1 : MODEL.nels

    Dofs = MODEL.ptrs(k, :);
    U_el = MODEL.U_dof(Dofs);

    POST.STEP(nincr).u(k, :) = [U_el(1), U_el(4)];
    POST.STEP(nincr).w(k, :) = [U_el(2), U_el(5)];
    POST.STEP(nincr).phi(k, :) = [U_el(3), U_el(6)];

end

end