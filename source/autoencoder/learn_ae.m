% Learns a binary RBM
%
% David Duvenaud
% Feb 2009
% ==========================================

function ae = learn_ae( train_data, num_hidden_units, method, noise )

if nargin < 4
    noise = 0;
end

if nargin < 4
    method = 'backprop'
end



[n, d ] = size( train_data );
num_visible_units = d;

learn_rate = 0.1 / n;

init_size = 0.1;
weights = rand( num_visible_units, num_hidden_units ) * init_size - init_size / 2;
hidden_bias = rand( num_hidden_units, 1 ) * init_size - init_size / 2;
visible_bias = rand( num_visible_units, 1 ) * init_size - init_size / 2;

orig_data = train_data;

if strcmp(method, 'backprop')
    % gradient descent learning     
    
    for iter = 1:8000
        
        %draw_weights( weights );
%        pause( 0.000001);

        if noise > 0
            train_data = orig_data;
            flips = rand( size( train_data )) < noise;
            train_data( flips ) = 0;% rand(size(train_data( flips ))) > 0.5;
        end        
        
        hidden = sigmoid( train_data * weights + repmat(hidden_bias', n, 1 ));       
        visible = sigmoid( hidden * weights' + repmat(visible_bias', n, 1 ));
        
        cost(iter) = -sum( sum( train_data .* log( visible ) + ( 1 - train_data ) .* log( 1 - visible )));

        %gradient = sum( ( train_data - visible ) * ( hidden + hidden * weights' * ( 1 - hidden ) * train_data ));
%         gradient = zeros( size( weights ));
%         for j = 1:num_hidden_units
%             for i = 1:num_visible_units            
%                 gradient( i, j ) = sum(( train_data( :, i ) - visible( :, i )) .* ...
%                     ( hidden( :, j ) + weights( i, j ) .* hidden( :, j ) .* ( 1 - hidden( :, j )) .* train_data( :, i)));
%             end
%         end                              
        
         data = orig_data;      % uncorrupted data
         gca = (data - visible)';
         gch = weights'*gca;
         gcaj = gch.*hidden'.*(1-hidden)';
         dW = (gcaj*train_data + hidden'*gca')';    %train_data might be noisy
         dbv = sum(gca');
         dbh = sum(gcaj');            
 
         weights = weights + dW * learn_rate;
         hidden_bias = hidden_bias + dbh' * learn_rate;
         visible_bias = visible_bias + dbv' * learn_rate;           
        
        %fprintf( '.' );
    end
    
    %figure; plot( cost ); title( 'Cross Entropy vs iterations');
end

% figure; draw_weights( weights );
% figure; draw_weights(visible' )
% figure; draw_weights(train_data' )
% figure; imagesc(hidden )

ae = struct;
ae.weights = weights;
ae.hidden_bias = hidden_bias;
ae.visible_bias = visible_bias;



        
    
    
