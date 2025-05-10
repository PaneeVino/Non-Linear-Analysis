function [N_xi, N_eta, N_z] = shape_function_20(xi, eta, z)

N1_xi = -(1/8*(1 - xi)*(1 - eta)*(1 - z) - (1 - eta)*(1 - z)*(eta + xi + z + 2)/8);
N1_eta = -((1/8 - xi/8)*(1 - eta)*(1 - z) + (1/8 - xi/8)*(z - 1)*(eta + xi + z + 2));
N1_z = -((1/8 - xi/8)*(1 - eta)*(1 - z) + (1/8 - xi/8)*(eta - 1)*(eta + xi + z + 2));

N2_xi = -(-(1 - eta)*(1 - z)*(xi/8 + 1/8) + (1 - eta)*(1 - z)*(eta - xi + z + 2)/8);
N2_eta = -((1 - eta)*(1 - z)*(xi/8 + 1/8) + (xi/8 + 1/8)*(z - 1)*(eta - xi + z + 2));
N2_z = -((1 - eta)*(1 - z)*(xi/8 + 1/8) + (eta - 1)*(xi/8 + 1/8)*(eta - xi + z + 2));

N3_xi = -(-(1 - z)*(eta + 1)*(xi/8 + 1/8) + (1 - z)*(eta + 1)*(-eta - xi + z + 2)/8);
N3_eta = -(-(1 - z)*(eta + 1)*(xi/8 + 1/8) + (1 - z)*(xi/8 + 1/8)*(-eta - xi + z + 2));
N3_z = -((1 - z)*(eta + 1)*(xi/8 + 1/8) + (-eta - 1)*(xi/8 + 1/8)*(-eta - xi + z + 2));

N4_xi = -((1/8 - xi/8)*(1 - z)*(eta + 1) - (1 - z)*(eta + 1)*(-eta + xi + z + 2)/8);
N4_eta = -(-(1/8 - xi/8)*(1 - z)*(eta + 1) + (1/8 - xi/8)*(1 - z)*(-eta + xi + z + 2));
N4_z = -((1/8 - xi/8)*(1 - z)*(eta + 1) + (1/8 - xi/8)*(-eta - 1)*(-eta + xi + z + 2));

N5_xi = -((1/8 - xi/8)*(1 - eta)*(z + 1) - (1 - eta)*(z + 1)*(eta + xi - z + 2)/8);
N5_eta = -((1/8 - xi/8)*(1 - eta)*(z + 1) + (1/8 - xi/8)*(-z - 1)*(eta + xi - z + 2));
N5_z = -(-(1/8 - xi/8)*(1 - eta)*(z + 1) + (1/8 - xi/8)*(1 - eta)*(eta + xi - z + 2));

N6_xi = -(-(1 - eta)*(xi/8 + 1/8)*(z + 1) + (1 - eta)*(z + 1)*(eta - xi - z + 2)/8);
N6_eta = -((1 - eta)*(xi/8 + 1/8)*(z + 1) + (xi/8 + 1/8)*(-z - 1)*(eta - xi - z + 2));
N6_z = -(-(1 - eta)*(xi/8 + 1/8)*(z + 1) + (1 - eta)*(xi/8 + 1/8)*(eta - xi - z + 2));

N7_xi = -(-(eta + 1)*(xi/8 + 1/8)*(z + 1) + (eta + 1)*(z + 1)*(-eta - xi - z + 2)/8);
N7_eta = -(-(eta + 1)*(xi/8 + 1/8)*(z + 1) + (xi/8 + 1/8)*(z + 1)*(-eta - xi - z + 2));
N7_z = -(-(eta + 1)*(xi/8 + 1/8)*(z + 1) + (eta + 1)*(xi/8 + 1/8)*(-eta - xi - z + 2));

N8_xi = -((1/8 - xi/8)*(eta + 1)*(z + 1) - (eta + 1)*(z + 1)*(-eta + xi - z + 2)/8);
N8_eta = -(-(1/8 - xi/8)*(eta + 1)*(z + 1) + (1/8 - xi/8)*(z + 1)*(-eta + xi - z + 2));
N8_z = -(-(1/8 - xi/8)*(eta + 1)*(z + 1) + (1/8 - xi/8)*(eta + 1)*(-eta + xi - z + 2));

N9_xi = (1/4 - xi/4)*(1 - eta)*(1 - z) - (1 - eta)*(1 - z)*(xi + 1)/4;
N9_eta = (1/4 - xi/4)*(1 - z)*(-xi - 1);
N9_z = -(1/4 - xi/4)*(1 - eta)*(xi + 1);

N10_xi = (1/4 - eta/4)*(1 - z)*(eta + 1);
N10_eta = (1/4 - eta/4)*(1 - z)*(xi + 1) - (1 - z)*(eta + 1)*(xi + 1)/4;
N10_z = -(1/4 - eta/4)*(eta + 1)*(xi + 1);

N11_xi = (1/4 - xi/4)*(1 - z)*(eta + 1) - (1 - z)*(eta + 1)*(xi + 1)/4;
N11_eta = (1/4 - xi/4)*(1 - z)*(xi + 1);
N11_z = -(1/4 - xi/4)*(eta + 1)*(xi + 1);

N12_xi = (1/4 - eta/4)*(1 - z)*(-eta - 1);
N12_eta = (1/4 - eta/4)*(1 - xi)*(1 - z) - (1 - xi)*(1 - z)*(eta + 1)/4;
N12_z = -(1/4 - eta/4)*(1 - xi)*(eta + 1);

N13_xi = (1/4 - xi/4)*(1 - eta)*(z + 1) - (1 - eta)*(xi + 1)*(z + 1)/4;
N13_eta = -(1/4 - xi/4)*(xi + 1)*(z + 1);
N13_z = (1/4 - xi/4)*(1 - eta)*(xi + 1);

N14_xi = (1/4 - eta/4)*(eta + 1)*(z + 1);
N14_eta = (1/4 - eta/4)*(xi + 1)*(z + 1) - (eta + 1)*(xi + 1)*(z + 1)/4;
N14_z = (1/4 - eta/4)*(eta + 1)*(xi + 1);

N15_xi = (1/4 - xi/4)*(eta + 1)*(z + 1) - (eta + 1)*(xi + 1)*(z + 1)/4;
N15_eta = (1/4 - xi/4)*(xi + 1)*(z + 1);
N15_z = (1/4 - xi/4)*(eta + 1)*(xi + 1);

N16_xi = -(1/4 - eta/4)*(eta + 1)*(z + 1);
N16_eta = (1/4 - eta/4)*(1 - xi)*(z + 1) - (1 - xi)*(eta + 1)*(z + 1)/4;
N16_z = (1/4 - eta/4)*(1 - xi)*(eta + 1);

N17_xi = -(1/4 - eta/4)*(-z + 1)*(z + 1);
N17_eta = -(1/4 - xi/4)*(-z + 1)*(z + 1);
N17_z = -z/2*(1 - xi)*(1 - eta);

N18_xi = (1/4 - eta/4)*(-z + 1)*(z + 1);
N18_eta = -(1/4 + xi/4)*(z + 1)*(-z + 1);
N18_z = -z/2*(1 + xi)*(1 - eta);

N19_xi = (1/4 - z/4)*(z + 1)*(eta + 1);
N19_eta = (1/4 + xi/4)*(z + 1)*(-z + 1);
N19_z = -z/2*(1 + xi)*(1 + eta);

N20_xi = -(1/4 - z/4)*(z + 1)*(eta + 1);
N20_eta = (1/4 - xi/4)*(z + 1)*(-z + 1);
N20_z = -z/2*(1 - xi)*(1 + eta);

%  vettori 
N_xi = [N1_xi, N2_xi, N3_xi, N4_xi, N5_xi, N6_xi, N7_xi, N8_xi, N9_xi, N10_xi, N11_xi, N12_xi, N13_xi, N14_xi, N15_xi, N16_xi, N17_xi, N18_xi, N19_xi, N20_xi];
N_eta = [N1_eta, N2_eta, N3_eta, N4_eta, N5_eta, N6_eta, N7_eta, N8_eta, N9_eta, N10_eta, N11_eta, N12_eta, N13_eta, N14_eta, N15_eta, N16_eta, N17_eta, N18_eta, N19_eta, N20_eta];
N_z = [N1_z, N2_z, N3_z, N4_z, N5_z, N6_z, N7_z, N8_z, N9_z, N10_z, N11_z, N12_z, N13_z, N14_z, N15_z, N16_z, N17_z, N18_z, N19_z, N20_z];

end