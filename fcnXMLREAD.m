function [...
matGEOM, valMAXTIME, valMINTIME, valDELTIME, valDELTAE, valDENSITY, valKINV, valVEHICLES, ...
matVEHORIG, vecVEHVINF, vecVEHALPHA, vecVEHBETA, vecVEHROLL, vecVEHPITCH, vecVEHYAW, ...
vecWINGS, vecWINGINCID, vecWINGAREA, vecWINGSPAN, vecWINGCMAC, vecWINGM, vecPANELS, ...
vecSYM, vecN, vecM, vecSECTIONS, matSECTIONS, vecSECTIONPANEL, vecWING, vecWINGVEHICLE, valPANELS...
] = fcnXMLREAD(filename)

% OUTPUT

% vecWINGVEHICLE - Rows are wing number, tells which vehicle each wing belongs to
% vecWING - Rows are panel number, tells which wing each panel belongs to
% vecSECTIONPANEL - Rows are section number, tells which panel each section belongs to
% valPANELS - Total number of panels
% vecPANELS - Rows are wing number, tells how many panels are on each wing
% vecWINGM - Rows are wing number, tells us the number of chordwise lifting lines on each wing
% vecWINGCMAC - Rows are wing number, tells us the mean aerodynamic chord of each wing
% vecWINGSPAN - Rows are wing number, tell us the span of each wing (tip to tip)
% vecSYM - Rows are panel number, tells us whether edge 1 or 2 of the panel has symmetry boundary condition
% vecN - Rows are panel number, tells us the number of spanwise DVEs for each panel
% vecM - Rows are panel number, tells us the number of chordwise DVEs for each panel (same as vecWINGM but on the DVE level)
% vecWINGINCID - Rows are wing number, tells us the incidence angle of the wing
% matSECTIONS - number of sections x 5 matrix of [x y z chord twist] for each section

%%
inp = fcnXML2STRUCT(filename);
VAP = inp.VAP;

%% Settings
if strcmpi(VAP.settings.flagRELAX.Text, 'true') flagRELAX = 1; else flagRELAX = 0; end
if strcmpi(VAP.settings.flagSTEADY.Text, 'true') flagSTEADY = 1; else flagSTEADY = 0; end
if strcmpi(VAP.settings.flagTRI.Text, 'true') flagTRI = 1; else flagTRI = 0; end

valMAXTIME = int32(str2double(VAP.settings.valMAXTIME.Text));
valMINTIME = int32(str2double(VAP.settings.valMINTIME.Text));
valDELTIME = str2double(VAP.settings.valDELTIME.Text);
valDELTAE = str2double(VAP.settings.valDELTAE.Text);

%% Conditions
valDENSITY = str2double(VAP.conditions.valDENSITY.Text);
valKINV = str2double(VAP.conditions.valKINV.Text);

%% Vehicles
valVEHICLES = max(size(VAP.vehicle));

matVEHORIG = nan(valVEHICLES,3);
vecVEHVINF = nan(valVEHICLES,1);
vecVEHALPHA = nan(valVEHICLES,1);
vecVEHBETA = nan(valVEHICLES,1);
vecVEHROLL = nan(valVEHICLES,1);
vecVEHPITCH = nan(valVEHICLES,1);
vecVEHYAW = nan(valVEHICLES,1);

vecWINGS = nan(valVEHICLES,1);

k = 1;
kk = 1;
kkk = 1;
for i = 1:valVEHICLES
    
    veh = VAP.vehicle{1,i};
    matVEHORIG(i,:) = [str2double(veh.x.Text) str2double(veh.y.Text) str2double(veh.z.Text)];
    vecVEHVINF(i,1) = str2double(veh.vinf.Text);
    vecVEHALPHA(i,1) = str2double(veh.alpha.Text);
    vecVEHBETA(i,1) = str2double(veh.beta.Text);
    vecVEHROLL(i,1) = str2double(veh.roll.Text);
    vecVEHPITCH(i,1) = str2double(veh.pitch.Text);
    vecVEHYAW(i,1) = str2double(veh.yaw.Text);
    
    vecWINGS(i,1) = max(size(veh.wing));
    
    for j = 1:vecWINGS(i)
        
        try win = veh.wing{1,j}; catch; win = veh.wing; end
        
        vecWINGINCID(k) = str2double(win.incidence.Text);
        if strcmpi(win.trimable.Text, 'true') vecTRIMABLE(j) = 1; else vecTRIMABLE(j) = 0; end
        vecWINGAREA(k) = str2double(win.area.Text);
        vecWINGSPAN(k) = str2double(win.span.Text);
        vecWINGCMAC(k) = str2double(win.cmac.Text);
        
        vecWINGM(k,1) = str2double(win.M.Text);
        
        vecPANELS(k,1) = max(size(win.panel));
        
        for m = 1:vecPANELS(k,1)
            
            try pan = win.panel{1,m}; catch; pan = win.panel; end
            
            vecSYMtemp(kk,1) = int32(str2double(pan.symmetry.Text));
            vecNtemp(kk,1) = floor(str2double(pan.N.Text));
            vecMtemp(kk,1) = floor(vecWINGM(k,1)); % Same for entire wing
            
            vecSECTIONS(kk,1) = max(size(pan.section));
            
            for n = 1:vecSECTIONS(kk,1)
               sec = pan.section{1,n};
                
               matSECTIONS(kkk,:) = [str2double(sec.x.Text) str2double(sec.y.Text) str2double(sec.z.Text) str2double(sec.chord.Text) vecWINGINCID(k)+str2double(sec.twist.Text)];
               vecSECTIONPANEL(kkk,1) = kk;
                
               kkk = kkk + 1;
            end
           
            vecPANELWING(kk,1) = k;
            
            kk = kk + 1;
        end
        
        vecWINGVEHICLE(k,1) = i;
        k = k + 1;
    end
    
valPANELS = sum(vecPANELS);
    
end

k = 1;

for i = 1:valPANELS
    
    sections = matSECTIONS(vecSECTIONPANEL == i,:);
    len = size(sections,1);
    
    if len == 2
        matGEOM(1,:,k) = sections(1,:);
        matGEOM(2,:,k) = sections(2,:);
        vecWING(k,1) = vecPANELWING(i);
        vecSYM(k,1) = vecSYMtemp(i);
        vecN(k,1) = vecNtemp(i);
        vecM(k,1) = vecMtemp(i);
        k = k + 1;
    else
        for j = 1:len - 1
            matGEOM(1,:,k) = sections(j,:);
            matGEOM(2,:,k) = sections(j+1,:);
            vecWING(k,1) = vecPANELWING(i);
           
            vecN(k,1) = vecNtemp(i);
            vecM(k,1) = vecMtemp(i);
            vecSYM(k,1) = 0;
            
            k = k + 1;
        end
        
        if vecSYMtemp(i) == 1
            vecSYM(k-len) = 1;
        elseif vecSYMtemp(i) == 2
            vecSYM(k-1) = 2;
        end
        
    end
end

valPANELS = size(matGEOM,3);


