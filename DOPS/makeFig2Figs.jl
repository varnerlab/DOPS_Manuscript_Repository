using DataFrames
using PyPlot

function makeFig2Figs()
	close("all")
	df = readtable("../DOPS_Results/performanceComparsion.csv")
	colors = ["#000000","#708090" , "#696969", "#A9A9A9"]
	cmap=ColorMap("gray")
	df=hcat(df, ["" for r in 1:size(df,1)]) #adding column for color
	rename!(df, [:x1], [:barcolor])
	#fill in the colors
	for k in collect(1:size(df,1))
		if(df[:opt_method][k]=="simulated_annealing")
			df[:barcolor][k]=colors[1] #cmap(1)
		elseif(df[:opt_method][k]=="PSO")
			df[:barcolor][k]=colors[2] #cmap(1)
		elseif(df[:opt_method][k]=="DE")
			df[:barcolor][k]=colors[3] #cmap(1)
		end
	end
	@show df
	functions = ["ackley_10d", "rast_10d", "rast_300d"]
	for f in functions
		reldata = df[df[:_function].==f,:]
		reldata = sort!(reldata, cols = [order(:num_evals)])
		figure()
		bar(collect(1:size(reldata,1)), reldata[:avg_scaled_err], yerr=reldata[:std_scaled_err], color=reldata[:barcolor],ecolor="k")
		title(f, fontsize=20)
		ylabel("Scaled Error (mean+std)", fontsize=16)
		ax=gca()
		ax[:xaxis][:set_ticks_position] = ([])
		savefig(string("../DOPS_Results/figures/",f, ".pdf"))
	end
	return df
end
