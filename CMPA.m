Is = 0.001E-12;
Ib = 0.1E-12;
Vb = 1.3;
Gp = 0.1;

% V =[-1.95:200:0.7];
V = linspace(-1.95,0.7,200);
% I = [];


I = (Is*exp((1.2./0.025).*V)-1) + Gp.*V - (Ib.*exp(-1.2./0.025.*(V+Vb))-1);

I2 = I + (2.*rand(1,200)-1).*I.*0.2; %random numbers from -1 to 1, and 20% of I

figure (1), plot(V, I);  %%fix
hold on
plot(V,I2);


figure (2), semilogy(V,abs(I));
hold on
semilogy(V,abs(I2))
%%polynoial fit

P4 = polyfit(V,I2,4);
P8 = polyfit(V,I2,8);

I4 = polyval(P4,V);
I8 = polyval(P8,V);

figure (3), plot(V, I4);

figure (4), semilogy(V, abs(I4));

figure (5), plot(V, I8);

figure (6), semilogy(V, abs(I8));

%non linear fitting

% fo = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');
% ff= fit(V,I,fo);
% 
% If = ff(x);

fo1 = fittype('A.*(exp(1.2*x/25e-3)-1) + Gp.*x - B*(exp(1.2*(-(x+Vb))/25e-3)-1)');
ff1= fit(V.',I.',fo1);

If1 = ff1(V.')

fo2 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+Vb))/25e-3)-1)');
ff2= fit(V.',I.',fo2);

If2 = ff2(V.')

fo3 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');
ff3= fit(V.',I.',fo3);

If3 = ff3(V.')

figure, plot(V,I2);
hold on
plot(V,If1);
plot(V, If2);
plot(V, If3);




%neutral net model


inputs = V.';
targets = I.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);
view(net)
Inn = outputs;

figure, plot(V,I2);
hold on
plot(V, Inn);

