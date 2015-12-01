nextData = [0 0 0]; % used to hold variable in the 'Manual' mode
send_mode = 'Manual'; % mode can be 'Manual' or 'Automatic'
windowWidth = 1000; %WindowWidth is the number of location points to keep
robotSize = 0.1651; %This is an actual-size robot, in meters

f = figure('Visible','off','Position',[360,200,700,450]);
set(f,'KeyPressFcn',@keypressfcn);
key = get(gcbf,'CurrentKey');
f_send = uicontrol('Style','pushbutton','String','Send Next Point',...
    'Position',[500,250,100,40],...
    'Callback',{@f_send_button_Callback});
f_text = uicontrol('Style','text','String','Select Mode',...
    'Position',[430,380,100,20]);
f_mode = uicontrol('Style','popupmenu',...
    'String',{'Manual','Automatic'},...
    'Position',[550,385,100,18],...
    'Callback',{@f_mode_menu_Callback});
f_a = axes('Units','Pixels','Position',[50,50,350,350]);
axis 'equal';
f_table = uitable(f,'Data',nextData,...
    'ColumnName',{'X (m)','Y(m)','Phi(deg)'},...
    'ColumnEditable', [true true true],...
    'RowName',[],...
    'Position',[420,300,228,50]);
set([f,f_a,f_send,f_text,f_mode,f_table],'Units','normalized');



xPos = linspace(0, 10, windowWidth*3);
yPos = linspace(0, 10, windowWidth*3);
Phi = 0;

while(1)
    
    robotXCenter = xPos(windowWidth*3);
    robotYCenter = yPos(windowWidth*3);
    cla(f_a);
    axis 'equal';
    p = plot(f_a, xPos, yPos, '.');
    
    blobColor = 'green';
    
    robotBlob = patch([robotXCenter-robotSize robotXCenter-robotSize robotXCenter robotXCenter+robotSize robotXCenter+robotSize], [robotYCenter-robotSize robotYCenter+robotSize robotYCenter+1.5*robotSize robotYCenter+robotSize robotYCenter-robotSize], blobColor);
    %Rotate the robot so that it points correctly
    rotate(robotBlob, [0,0,1], Phi - 90, [robotXCenter, robotYCenter, 0]);
    
    
    
    set(f,'Name','2.12 Lab 3 Matlab Interface');% Assign the GUI a name to appear in the window title.
    set(f,'Visible','on');% Make the GUI visible.
    drawnow
    
    if strcmp(f,'')
    elseif strcmp(f,'leftarrow')
        %     fwrite(serialConnection,num2str(nextData(1)));
        %     fwrite(serialConnection,',');
        %     fwrite(serialConnection,num2str(nextData(2)));
        %     fwrite(serialConnection,',');
        %     fwrite(serialConnection,num2str(pi/180*nextData(3)));
        %     fwrite(serialConnection,'\n');
        Phi = Phi - 1;
    elseif strcmp(f,'uparrow')
        %     fwrite(serialConnection,num2str(nextData(1)));
        %     fwrite(serialConnection,',');
        %     fwrite(serialConnection,num2str(nextData(2)));
        %     fwrite(serialConnection,',');
        %     fwrite(serialConnection,num2str(pi/180*nextData(3)));
        %     fwrite(serialConnection,'\n');
        xPos = [xPos ; cos(Phi)];
        yPos = [yPos ; sin(Phi)];
    elseif strcmp(f,'rightarrow')
        %     fwrite(serialConnection,num2str(nextData(1)));
        %     fwrite(serialConnection,',');
        %     fwrite(serialConnection,num2str(nextData(2)));
        %     fwrite(serialConnection,',');
        %     fwrite(serialConnection,num2str(pi/180*nextData(3)));
        %     fwrite(serialConnection,'\n');
        Phi = Phi + 1;
    elseif strcmp(f,'downarrow')
        %     fwrite(serialConnection,num2str(nextData(1)));
        %     fwrite(serialConnection,',');
        %     fwrite(serialConnection,num2str(nextData(2)));
        %     fwrite(serialConnection,',');
        %     fwrite(serialConnection,num2str(pi/180*nextData(3)));
        %     fwrite(serialConnection,'\n');
        xPos = [xPos ; -cos(Phi)];
        yPos = [yPos ; -sin(Phi)];
    elseif strcmp(f,'return')
    end;
    
end
