function PrintImages(fig_seq,folder)
    for i = 1:length(fig_seq)
        fig_index = fig_seq(i);
        fig = figure(fig_index);
        print(fig,[folder,'wave_' num2str(fig_index)], '-djpeg','-r300');

    end
end