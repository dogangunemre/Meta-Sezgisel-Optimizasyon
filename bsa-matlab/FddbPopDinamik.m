function boolean = FddbPopDinamik( population, fitness, XoldIndex, Xnew, XNewFitnes, maxIteration, iter)
    % FDB skor hesaplamasi yapar. Bu skor populasyondaki
    % uygunluk degeri en iyi olan çözüm adayina Xbest der isek,
    % Xbest'in parametreleri ve uygunluk degerine olan uzakliklarinin toplamidir. 
    % Olusturulacak fonksiyonun almasi gereken parametreler sirasiyla
    % Xbest ve XbestFitness
    % Xeski ve XeskiFitness
    % Xnew ve XnewFitness

    %Populasyon(1) => Xeski cozum adayý
    %Populasyon(2) => Xnew cozum adayý
    %Populasyon(3) => Xworst
    %Populasyon(4) => Xbest cozum adayý
    
    [FDDBPopulasyon] = createdFdbPopulasyon(population, fitness, XoldIndex, Xnew, XNewFitnes);
    if ( FDDBPopulasyon(3).Fitness < FDDBPopulasyon(2).Fitness ) %% yeni cozum adayi eger Xwort'en daha kotu ise guncelleme yapma
        boolean = 0;
    elseif ( FDDBPopulasyon(4).Fitness == FDDBPopulasyon(3).Fitness )
        boolean = 1;
    elseif ( FDDBPopulasyon(4).Fitness > FDDBPopulasyon(2).Fitness )
     %Xnew, popï¿½lasyondaki Xbest'ten daha iyi ise, skor hesaplamasï¿½
     %yapï¿½lmadan yer deï¿½iï¿½tiriliyor.
        boolean = 1;
    elseif ( FDDBPopulasyon(4).Fitness == FDDBPopulasyon(1).Fitness )
        boolean = 0;
    else
        [MerkezSayisi, dimention] = size(population); % satýrlar populasyonSize olmalý. Eðer deðil ise population' þeklinde gönderilmelidir.
        frekans = 10;
        divDistances = calculateDivDistances(FDDBPopulasyon, population, fitness, MerkezSayisi, frekans, maxIteration, iter);
        boolean = checkDivDistance(divDistances);
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
function [divDistances] = calculateDivDistances(FDDBPopulasyon, population, fitness, MerkezSayisi, frekans, maxFe, iter)

    [~, dimension] = size(population);
    normDistancespopMerkez = calculatePopMerkezNormDistances(FDDBPopulasyon, population, fitness, MerkezSayisi, 4, dimension);
    normFitness = calculateNormFitness(FDDBPopulasyon, 2); % 2 verildi!! Xold ve Xnew iï¿½in skorlama yapï¿½lacaktï¿½r!!!
    normDistances = calculateNormDistances(FDDBPopulasyon, 3, dimension);
    multiplierArray = calculateFddbMultiplier (frekans, maxFe, iter);
    divDistances = calculateFDDBSkore(2, normDistancespopMerkez, normFitness, normDistances, multiplierArray);
end

function [boolean] = checkDivDistance(divDistances)

    if divDistances(2) > divDistances(1)
        boolean = 1;
    else
        boolean = 0;
    end
end

function [normDistancespopMerkez] = calculatePopMerkezNormDistances(FDDDPopulasyon, Populasyon, Fitness, MerkezSayisi, populationSize, dimension)

    popMerkez = calculatePopMerkez(Populasyon, Fitness, MerkezSayisi);
    distancesPopMerkez = zeros(1, populationSize);
    normDistancespopMerkez = zeros(1, populationSize);

    for populasyonIndex = 1 : populationSize 
        value = 0;
        for dimensionIndex = 1 : dimension
            value = value + abs( popMerkez(dimensionIndex) - FDDDPopulasyon(populasyonIndex).Dimension(dimensionIndex) );
        end
        distancesPopMerkez(populasyonIndex) = value;
    end

    minDistancepopMerkez  = min(distancesPopMerkez);
    maxMinDistancepopMerkez  = max(distancesPopMerkez) - minDistancepopMerkez;

    for index = 1 :  populationSize 
        normDistancespopMerkez(index) = (distancesPopMerkez(index) - minDistancepopMerkez) / maxMinDistancepopMerkez;
    end
end

function [popMerkez] = calculatePopMerkez(Populasyon, Fitness, MerkezSayisi)

    [~, sortIndex] = sort(Fitness);
    if MerkezSayisi <= 1
        MerkezSayisi = 2;
    end
    popMerkez = sum(Populasyon(sortIndex(1:MerkezSayisi),:)) / MerkezSayisi;
end

function [normFitness] = calculateNormFitness(FDDBPopulasyon, populationSize)

    normFitness = zeros(1, populationSize); 
    minFitness = FDDBPopulasyon(4).Fitness; 
    maxMinFitness = FDDBPopulasyon(3).Fitness - minFitness;
    for populasyonIndex = 1 : populationSize
        normFitness(populasyonIndex) = 1 - ( (FDDBPopulasyon(populasyonIndex).Fitness - minFitness) / maxMinFitness );
    end
end

function [normDistances] = calculateNormDistances(FDDDPopulasyon, populationSize, dimension)

    distances = zeros(1, populationSize); 
    normDistances = zeros(1, populationSize); 
    
    for populasyonIndex = 1 : populationSize 
        value = 0;
        for dimensionIndex = 1 : dimension
            value = value + abs( FDDDPopulasyon(4).Dimension(dimensionIndex) - FDDDPopulasyon(populasyonIndex).Dimension(dimensionIndex) );
        end
        distances(populasyonIndex) = value;
    end
    
    minDistance = 0; % bestin kendine olan uzaklï¿½ï¿½ï¿½ 0'dï¿½r;
    maxMinDistance = max(distances) - minDistance;

    for i = 1 : populationSize
        normDistances(i) = (distances(i) - minDistance) / maxMinDistance;
    end
end

function [fddbMultiplier] = calculateFddbMultiplier (frekans, maxFe, iter)
    fddbMultiplier = zeros(1,3);
    if (frekans == 0) || (iter > maxFe)
        fddbMultiplier(1) = 0.6;
        fddbMultiplier(2) = 0.25;
        fddbMultiplier(3) = 0.15;
    else
        fx = round(maxFe / frekans);
        y = mod(iter, fx);
        fddbMultiplier(1) = (y / fx) * (1 - 0.4) + 0.4;
        fddbMultiplier(3) = (1 - fddbMultiplier(1)) / 2.4;
        fddbMultiplier(2) = 1.4 * fddbMultiplier(3);
    end
end

function [divDistances] = calculateFDDBSkore(populationSize, normDistancespopMerkez, normFitness, normDistances, multiplierArray)
    divDistances = zeros(1, populationSize);
    for i = 1 : populationSize
        divDistances(i) = (multiplierArray(1) * normFitness(i)) + (multiplierArray(2) * normDistances(i)) + (multiplierArray(3) * normDistancespopMerkez(i));
    end
end
