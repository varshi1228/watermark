close all;  clc, clear variables
 
% Ver.1.0 .
% Use the simple Menu to control the program flow, but mind the order of the steps. 
% Unmarked image has to be grayscale. If a color image is selected,  
% it is coverted into grayscale image.
    
global K dim_bloka Nivo faktor Vs Ss vis_ziga sir_ziga

    step = 0;
    the_end = 8;

while step ~= the_end
    
    step = menu('Image Watermarking Procedure',...
    '1. Read unmarked intensity image',...
    '2. Read the watermark (binary image)',...
    '3. Select transformation (DCT / DWT)',...
    '4. Mark the image',...
    '5. Attack/degrade the marked image',...
    '6. Read a marked intensity image',...
    '7. Detect and extract the watermark image',...
    ' Exit ');
    

    K = 14;    % "Jacina ziga" u [%], tj. procenat promene koeficijenata
    dim_bloka = 8; % Velicina DCT bloka je 8x8
    Nivo = 3; % Nivo dekompozicije kod Wavelet transformacije
    % Nivo = round(log10(dim_bloka)/log10(2))
    
    % 1. Read unmarked intensity image ----------------------------
    if step == 1
        img_file = 'input\\lena_gray_512.tif';
        %img_file = input('Unesite naziv originalne slike:   ');
        Unmarked_image = imread(img_file);
        if length(size(Unmarked_image)) ~= 2
            disp('Slika mora biti dimenzija MxN.');
            Unmarked_image = rgb2gray(Unmarked_image);
            % Ulazne slike su intenzitetne slike.
        end
        figure(1), imshow(Unmarked_image), title('Unmarked image')
        [slika, Vs, Ss] = podes_slike(Unmarked_image);
        faktor = norm_faktor(slika);
        slika = double(slika)/faktor;
        % Dimenzije ziga
        vis_ziga = Vs/dim_bloka;
        sir_ziga = Ss/dim_bloka;
        vel_ziga = vis_ziga * sir_ziga;
    end
        
    % 2. Read watermark (binary image with pixels 0 or 1) ---------------------------------
    if step == 2
        watermark = 'input\\watermark.jpeg';
        tmp_zig = imread(watermark);
        orig_zig = zeros(size(tmp_zig));
        tmp_zig = tmp_zig/max(max(tmp_zig));
        preko = find(tmp_zig >= 0.5);
        orig_zig(preko) = ones(size(preko));
        figure(2), imshow(orig_zig), title('Original watermark')
        zig = podes_ziga(orig_zig);
    end
    
    % 3. Select method (DCT or Wavelet) ---------------------------------
    if step == 3
        m = 0;
        while m ~= 3
            m = menu('Select method',...
                'DCT', 'Wavelet', 'OK');
            if m == 1
                metod = 1;
                disp('DCT')
                break
            end
            if m == 2
                metod = 2;
                disp('Wavelet')
                break
            end
        end
    end
        
    % 4. Mark an image (incorporate the watermark) ----------------------
    if step == 4
        % Key for PSS generator
        key = 1682004; %TODO: make it an input
        % MATLAB PSS generator is set to init state def by the key 
        rng(key);
        % PSS Permute the watermark
        a1 = randperm(vel_ziga);
        clear key; % delete key
        a2 = reshape(a1, vis_ziga, sir_ziga);
        skrembl_zig = zig(a2);
        skrembl_zig1 = (skrembl_zig - 0.5)/0.5; % -1 i 1
        % skrembl_zig1 is type double
        if metod == 1
            Marked_image = ugradnja_DCT(slika, skrembl_zig1);
        elseif metod == 2
            Marked_image = ugradnja_DWT(slika, skrembl_zig1);
        else
            error('\n Error. Unsupported method.');
        end
        figure(5), imshow(Marked_image), title('Marked image')
        Marked_image_uint8 = uint8(Marked_image * faktor);
        imwrite(Marked_image_uint8, 'output\\Marked_image.tif');
    end
    
    % 5. Attak/degrade the image --------------------------------------------------
    % no breaks so that combinations are possible
    if step == 5
        k = 0;
        output_folder = 'output\\';
        while k ~= 7
            k = menu('Napad na slikuAttak/degrade the image',...
                'JPEG compression', 'Brightness',...
                'Contrast','Cropping','Filtering',...
                'Noise','OK');
            if k == 1
                attack = compression(Marked_image_uint8, output_folder);
                %generates images that start with: JPEG_Mkd_img_
            end
            if k == 2
                attack = brightness(Marked_image, output_folder);
                %generates images that start with: Bright_Mkd_img_
            end
            if k == 3
                attack = contrast(Marked_image, output_folder);
                %generates images that start with: Mcon_Mkd_img_
                %generates images that start with: Hcon_Mkd_img_
            end
            if k == 4
                attack = cropping(Marked_image_uint8, output_folder);
                %generates images that start with: Vcrop_Mkd_img_
                %generates images that start with: VScrop_Mkd_img_
            end
            if k == 5
                attack = filtering(Marked_image_uint8, output_folder);
                %generates images that start with: Filt_Mkd_img_
            end
            if k == 6
                attack = noise(Marked_image_uint8, output_folder);
                %generates images that start with: Noise_Mkd_img_
            end
        end
        disp(attack);
    end
    
    % 6. Read marked intensity/grayscale image --------------------------
    if step == 6
        img_file = input('\n Enter marked intensity/grayscale image:   ');
        full_path = strcat(output_folder,img_file);
        Marked_image = imread(full_path);
        if length(size(Marked_image)) ~= 2
            disp('Image dimensions have to be MxN pixels.');
            Marked_image = rgb2gray(Marked_image); % convert to grayscale
        end
        faktor = norm_faktor(Marked_image);
        Marked_image = double(Marked_image)/faktor;
        % Dimensions of unmarked and marked image are the same.
        figure(6),imshow(Marked_image), title('Marked image (read)')
    end
    
    % 7. Detect watermark -----------------------
    if step == 7
        % Key for PSS generator
        key = 1682004;
        %key = input('\n Enter the password:   ');
        rng(key);
        % Undo the permutation of the watermark.
        b1 = randperm(vel_ziga);
        clear key; % delete key
        b2 = reshape(b1, vis_ziga, sir_ziga);
        if metod == 1
            rek_zig = izdvajanje_DCT(slika, Marked_image, b2);
        elseif metod == 2
            rek_zig = izdvajanje_DWT(slika, Marked_image, b2);
        else
            error('\n Error. Unsupported method.');
        end
        figure(7),imshow(rek_zig),title('Detected watermark')
        % Korelacije originalnog i detektovanog ziga 
        kkor_zigova = corr2(zig, rek_zig);
        fprintf('\n Correlation Coefficient of the watermarks   %f', kkor_zigova)
        nkor_zigova = sum(sum(rek_zig .* zig))/sum(sum(zig.^2));
        fprintf('\n Normalized Correlation of the watermarks   %f', nkor_zigova)
        % Korelacije originalne i oznacene slike
        kkor_slika = corr2(slika, Marked_image);
        fprintf('\n Correlation Coefficient of the images   %f', kkor_slika)
        nkor_slika = sum(sum(Marked_image .* slika))/sum(sum(slika.^2));
        fprintf('\n Normalized Correlation of the images   %f  \n', nkor_slika)
        % Broj pogresnih bitova u detektovanom zigu
        greska = abs(rek_zig - zig);
        br_pogr_bita = sum(sum(greska));
        fprintf('\n Num of bit errors in detected watermark %i   ', ...
            br_pogr_bita)
        procenat_pogr_bita = (br_pogr_bita/vel_ziga)*100;
        fprintf('\n Percent of bit errors (BER) in detected watermark %f  \n',...
            procenat_pogr_bita)
        disp('*******************************************************')
    end
    %    THE END  -----------------------------------------------------
end
clc