function boolean = FdbPopArtnDu( Populasyon, Fitnes, XoldIndex, Xnew, XNewFitnes, maxIteration, iter )

    % FDB skor hesaplamasi yapar. Bu skor populasyondaki
    % uygunluk degeri en iyi olan ��z�m adayina Xbest der isek,
    % Xbest'in parametreleri ve uygunluk degerine olan uzakliklarinin toplamidir. 
    % Olusturulacak fonksiyonun almasi gereken parametreler sirasiyla
    % Xbest ve XbestFitness
    % Xeski ve XeskiFitness
    % Xnew ve XnewFitness

    %Populasyon(1) => Xeski cozum aday�
    %Populasyon(2) => Xnew cozum aday�
    %Populasyon(3) => Xworst
    
    [FDBPopulasyon] = createdFdbPopulasyon(Populasyon, Fitnes, XoldIndex, Xnew, XNewFitnes);

    if ( FDBPopulasyon(3).Fitness < FDBPopulasyon(2).Fitness )
        boolean = 0;
    elseif ( FDBPopulasyon(4).Fitness == FDBPopulasyon(3).Fitness )
        boolean = 1;
    elseif FDBPopulasyon(4).Fitness > FDBPopulasyon(2).Fitness 
     %Xnew, pop�lasyondaki Xbest'ten daha iyi ise, skor hesaplamas�
     %yap�lmadan yer de�i�tiriliyor.
        boolean = 1;
    elseif FDBPopulasyon(4).Fitness == FDBPopulasyon(1).Fitness 
        boolean = 0;
    else
        
        w = ArtanUcgen(maxIteration, iter);
        populationSize = 3; % Xeski Xnew i�in skor hesaplamas�. Xbest her zaman 1'dir. Xworst normalize i�in
        [~, dimension] = size(FDBPopulasyon(1).Dimension);

        distances = zeros(1, populationSize); 
        normFitness = zeros(1, populationSize - 1); 
        normDistances = zeros(1, populationSize - 1); 
        divDistances = zeros(1, populationSize - 1); 

        for populasyonIndex = 1 : populationSize 
            value = 0;
            for dimensionIndex = 1 : dimension
                value = value + abs(FDBPopulasyon(4).Dimension(dimensionIndex) - FDBPopulasyon(populasyonIndex).Dimension(dimensionIndex));
            end
            distances(populasyonIndex) = value;
        end

        minFitness = FDBPopulasyon(4).Fitness; maxMinFitness = FDBPopulasyon(3).Fitness - minFitness;
        minDistance = 0; %bestin kendine olan uzakl��� s�f�rd�r.
        maxMinDistance = max(distances) - minDistance;

        for index = 1 :  2 % ( populationSize - 1 )
            normFitness(index) = 1 - ((FDBPopulasyon(index).Fitness - minFitness) / maxMinFitness);
            normDistances(index) = (distances(index) - minDistance) / maxMinDistance;
            divDistances(index) = (1-w)*normFitness(index) + w*normDistances(index);
        end
        if divDistances(2) > divDistances(1)
            boolean = 1;
        else
            boolean = 0;
        end
    end
end
function [FDBPopulasyon] = createdFdbPopulasyon(Populasyon, Fitnes, XoldIndex, XnewDimension, XNewFitnes)
        [~, worstIndex] = max(Fitnes); 
        [~, bestIndex] = min(Fitnes);
        
        FDBPopulasyon(1).Fitness = Fitnes(XoldIndex);
        FDBPopulasyon(1).Dimension = Populasyon(XoldIndex,:);

        FDBPopulasyon(2).Fitness = XNewFitnes;
        FDBPopulasyon(2).Dimension = XnewDimension;

        FDBPopulasyon(3).Fitness = Fitnes(worstIndex);
        FDBPopulasyon(3).Dimension = Populasyon(worstIndex,:);

        FDBPopulasyon(4).Fitness = Fitnes(bestIndex);
        FDBPopulasyon(4).Dimension = Populasyon(bestIndex,:);
end
function w = ArtanUcgen(maxIteration, iter)
    if iter>maxIteration
        w = 0.5;
    else
        fx = round(maxIteration / 10);
        y = mod(iter, fx);
        w = ( ( (fx-y) / fx) * -0.6 ) + 0.6;
    end

end
