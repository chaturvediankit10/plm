module SearchHelper
	def get_results(result, term)
		return result.map{|t| t if t[:term] == term}.compact
	end

	def get_results_arm(result,arm)
		return result.map{|t| t if t[:arm_basic] == arm}.compact
	end

	def closing_costs_filter(adjustment_pair)
		begin
			repeated_arr = []
			adj_data = {}
			adj_hash = {}
	    adjustment_pair.to_a.map{|k, v| adj_data[k] = v if v!=0.0}
			if adj_data.keys.count<=5
				adj_data.to_a.each do |key, value|
					key_arr = key.split('/')
					assigned = false
					key_arr.each do |sub_key|
						if !repeated_arr.include?(sub_key) && !assigned
							repeated_arr << sub_key
							assigned = true
							if key_arr.length>=3
								adj_hash[sub_key] = value
							else
								adj_hash[key] = value
							end
						end
					end
					if (!assigned)
						adj_hash[key_arr[0]] = value
					end
				end
			else
				i = 0;
				other_value = 0;
				adj_data.to_a.each do |key, value|
					key_arr = key.split('/')
						assigned = false
						i = i+1
						if i<5	
							key_arr.each do |sub_key|
								if !repeated_arr.include?(sub_key) && !assigned
									repeated_arr << sub_key
									assigned = true
									if key_arr.length>=3
										adj_hash[sub_key] = value
									else
										adj_hash[key] = value
									end
								end
							end
							if (!assigned)
								adj_hash[key_arr[0]] = value
							end
						else
							other_value = other_value + value
							adj_hash['Other'] = other_value
						end
				end
			end
			return adj_hash.to_a
		rescue
			puts "Error in 'closing_costs_filter' method"
		end
	end

	def adj_key_name(primary_key)
		begin
			key = ''
			arr = ["FICO", "LTV", "CLTV", "FHA", "USDA", "VA"]
			primary_key.split('/').each do |p|
				if p=="FICO"
					p = "Credit Score"
				end
				key = key+(arr.include?(p) ? p : p.titleize)+'/'
			end
			return key[0..-2]
		rescue
			puts "Error in 'adj_key_name' method"
		end
	end

	def closing_cost_sum(adj_points, starting_base_point)
		adj_points << starting_base_point
		return adj_points.sum
	end
	def adj_key_value(program, primary_key)
		begin
			arr = %w[state_code term financing_type refinance_option property_type misc_adjuster premium_type interest lock_period program_category dti home_price down_payment point_mode arm_basic arm_advanced arm_caps arm_benchmark arm_margin full_doc  term loan_size]
			program_arr = %w[loan_category term loan_type loan_purpose fha va usda]
			key_value = ''
			primary_key.split("/").each do |key|
				key = "credit_score" if key == "FICO"
				key = "lock_period" if key == "LockDay"
				key = "state_code" if key == "State"
				key = "ltv" if key == "CLTV"

				if arr.include?(key.underscore)
					value = instance_variable_get("@"+key.underscore).to_s
					key_value  = key_value + '/' if key_value.present? && value.present?
					key_value = key_value + value if value.present?
				elsif key.underscore == "ltv" || key.underscore == "credit_score"
					value = instance_variable_get("@set_"+key.underscore).to_s
					key_value  = key_value + '/' if key_value.present? && value.present?
					key_value = key_value + value if value.present?
				elsif key.underscore == "loan_amount"
					value = (@home_price.to_i - @down_payment.to_i).to_s
					key_value  = key_value + '/' if key_value.present? && value.present?
					key_value = key_value + value if value.present?
				elsif program_arr.include?(key.underscore)
					value = program[key.underscore.to_sym].to_s
					value = "Yes" if value=='true'
					key_value  = key_value + '/' if key_value.present? && value.present?
					key_value = key_value + value if value.present?
				end
			end
			return key_value
		rescue
			puts "Error in 'adj_key_value' method"
		end
	end
end