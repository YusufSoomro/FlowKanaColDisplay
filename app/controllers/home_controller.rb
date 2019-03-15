class HomeController < ApplicationController
	def show
		@inputted_values = params["input_values"]&.split(",")

		if !@inputted_values
			render "show" and return
		elsif @inputted_values.count > 100
			flash.now[:error] = "Uh oh! You must input 100 values or less" 
			render "show" and return
		end

		if @inputted_values.count > (@column_count = params["column_count"].to_i)
			rows_required = (@inputted_values.count.to_f / @column_count).ceil
			@data_for_table = Array.new(rows_required) { [] }
			remainder = @inputted_values.count % @column_count

			until @inputted_values.empty?
				@data_for_table.each do |row|
					is_last_row = @data_for_table.last.equal?(row)
					table_data = if (is_last_row && remainder != 0 && row.count >= remainder)
									nil
								 else
									@inputted_values.shift
								 end

					row << table_data
				end
			end
		end

		render "show"
	end
end