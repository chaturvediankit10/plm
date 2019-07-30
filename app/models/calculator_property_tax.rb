require 'roo'
class CalculatorPropertyTax < ApplicationRecord

	def self.calculator_import_csv_file
    file = File.join(Rails.root, 'state_and_city_related_data.xlsx')
    xlsx = Roo::Spreadsheet.open(file)
    xlsx.sheets.each do |sheet|
      if (sheet == "The Table of Average Cost of Homeowners Insurance")
        sheet_data = xlsx.sheet(sheet)
        (2..52).each do |r|
          row = sheet_data.row(r)
          home_insurance = {}
          if (row.compact.count > 1)
            home_insurance[:state_code] = sheet_data.cell(r,1)
            home_insurance[:insurance_rate] = sheet_data.cell(r,2)
            home_insurance[:avg_annual_insurance] = sheet_data.cell(r,3)
            CalculatorHomeInsurance.find_or_create_by(home_insurance)
          else
            break;
          end
        end
      end

      if (sheet == "Price-to-Rent Ratio in 76 US Cities")
        sheet_data = xlsx.sheet(sheet)
        (2..83).each do |r|
          rent_ratio={}
          row = sheet_data.row(r)
          if (row.compact.count > 1)
            rent_ratio[:city] = sheet_data.cell(r,1)
            rent_ratio[:state_code] = sheet_data.cell(r,2)
            rent_ratio[:price_rent_ratio] = sheet_data.cell(r,3)
            CalculatorPriceToRentRatio.find_or_create_by(rent_ratio)
          else
            break;
          end
        end
      end

      if (sheet == "CA Affordability Data")
        sheet_data = xlsx.sheet(sheet)
        cs_hash={}
        nation_wide={}
        (2..517).each do |r|
          row = sheet_data.row(r)
          if (row.compact.count > 1)
            cs_hash[:home_price_index] = sheet_data.cell(r,2)
            cs_hash[:date] = sheet_data.cell(r,1)
            cs_hash[:state_code] = "CA"

            nation_wide[:home_price_index] = sheet_data.cell(r,3)
            nation_wide[:date] = sheet_data.cell(r,1)
            nation_wide[:state_code] = "Nationwide"

            CalculatorHomeAffordability.find_or_create_by(cs_hash)
            CalculatorHomeAffordability.find_or_create_by(nation_wide)
          else
            break;
          end
        end
      end

      if (sheet == "The Table of Property Tax Percentage")
        sheet_data = xlsx.sheet(sheet)
        (2..52).each do |r|
          row = sheet_data.row(r)
          property_tax = {}
          if (row.compact.count > 1)
            property_tax[:state_code] =  sheet_data.cell(r,1)
            property_tax[:tax_rate] =  sheet_data.cell(r,2)
            CalculatorPropertyTax.find_or_create_by(property_tax)
          else
            break;
          end
        end
      end
    end 
  end
end
