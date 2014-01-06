function [x, vld] = modlinear(a, b, p, field_inv)
%Modified GFLINEQ 
% Find a particular solution of Ax = b over a prime Galois field.
%   X = GFLINEQ(A, B) outputs a particular solution of the linear
%   equation A X = B in GF(2).  The elements in A, B and X are either
%   0 or 1.  If the equation has no solution, then X is empty.
%
%   X = GFLINEQ(A, B, P) outputs a particular solution of the linear
%   equation A X = B in GF(P).  The elements in A, B and X are integers
%   between 0 and P-1.
%
%   [X, VLD] = GFLINEQ(...) outputs a flag that indicates the existence
%   of a solution. If VLD = 1, then the solution X exists and is valid.
%   If VLD = 0, then no solution exists. 
%
%   Note: This function performs computations in GF(P) where P is prime. To work
%   in GF(2^M), you can also apply the \ or / operator to Galois arrays.
%
%   See also GFADD, GFDIV, GFROOTS, GFRANK, GFCONV, CONV.

%   Copyright 1996-2011 The MathWorks, Inc.

% Error checking.
error(nargchk(2, 4, nargin,'struct'));

% Error checking - P.
if nargin < 3
    p = 2;
elseif ( isempty(p) || numel(p)~=1 || abs(p)~=p || floor(p)~=p || ~isprime(p) )
    error(message('comm:gflineq:InvalidP'));
end;

[m_a, n_a] = size(a);
[m_b, n_b] = size(b);

% Error checking - A & B.
if ( isempty(a) || ndims(a) > 2 )
    error(message('comm:gflineq:InvalidA'));
end
if ( isempty(b) || ndims(b) > 2 || n_b > 1 )
    error(message('comm:gflineq:InvalidB'));
end
if ( m_a ~= m_b )
    error(message('comm:gflineq:InvalidAB'));
end
if ( any(any( abs(a)~=a | floor(a)~=a | a>=p )) )
    if ( p == 2 )
        error(message('comm:gflineq:InvalidAForP2'));
    else
        error(message('comm:gflineq:InvalidAElements'));
    end
end
if ( any(any( abs(b)~=b | floor(b)~=b | b>=p )) )
    if ( p == 2 )
        error(message('comm:gflineq:InvalidBForP2'));
    else
        error(message('comm:gflineq:InvalidBElements'));
    end
end    

% Construct an AA = [A, B] composite matrix and assign initial values.
aa = [a b];
[m_aa, n_aa] = size(aa);

row_idx = 1;
column_idx = 1;
row_store = [];
column_store = [];

% Search for major elements, trying to form 'identity' matrix.
while (row_idx <= m_aa) && (column_idx < n_aa)

    % Look for a major element in the current column.
    while (aa(row_idx,column_idx) == 0) && (column_idx < n_aa)

        % In the current column, search below all the rows that already
        % have major elements.
        idx = find( aa(row_idx:m_aa, column_idx) ~= 0 );

        if isempty(idx)
            % There are no major elements in this column.
            % Move to the next column.
            column_idx = column_idx + 1;
            
        else
            % There is a major element in this column.
            % See if any are already equal to one.            
            idx = [ find(aa(row_idx:m_aa, column_idx) == 1); idx ];
            idx = idx(1);

            % Swap the current row with a row containing a major element.
            temp_row = aa(row_idx,:);
            aa(row_idx,:) = aa(row_idx+idx-1,:);
            aa(row_idx+idx-1,:) = temp_row;

        end
    end


    % Clear all non-zero elements in the column except the major element,
    % and set the major element to one.
    if ( ( aa(row_idx,column_idx) ~= 0 ) && ( column_idx < n_aa ) )

        % The current element is a major element.
        row_store = [row_store row_idx];
        column_store = [column_store column_idx];

        % If the major element is not already one, set it to one.
        if (aa(row_idx,column_idx) ~= 1)
           aa(row_idx,:) = mod( field_inv( aa(row_idx,column_idx) ) * aa(row_idx,:), p );
        end;

        % Find the other elements in the column that must be cleared,
        idx = find(aa(:,column_idx)~=0)';
        % and set those elements to zero.
        for i = idx
            if i ~= row_idx
                aa(i,:) = mod( aa(i,:) + aa(row_idx,:) * (p - aa(i,column_idx)), p );
            end
        end

        column_idx = column_idx + 1;

    end

    row_idx = row_idx + 1;

end

if ( rank(double(aa)) > rank( double(aa(:,1:n_a)) ) )
    % The case of no solution.
    warning(message('comm:gflineq:NoSolution'));
    x = [];
    vld = 0;
else
    x = int64(zeros(n_a, 1));
    x(column_store,1) = aa(row_store,n_aa);
    vld = 1;
    x(x > (p / 2)) = x(x > (p / 2)) - p;
end

