# require 'date'
# # payments = [
# # 	{ account_id: 1, payment: 400},
# # 	{ account_id: 1, payment: 400},
# # 	{ account_id: 1, payment: 400},
# # 	{ account_id: 2, payment: 400},
# # 	{ account_id: 2, payment: 400},
# # 	{ account_id: 3, payment: 400},
# # 	{ account_id: 2, payment: 400}
# # ]

# # Calculates how many months are required to pay down debt amount.
# apr = 15.94 / 100
# monthly_interest = apr / 12
# principal = 5000
# monthly_payment = 2500
# month = Date.today

# num_months = -Math.log(1 - (monthly_interest * principal) / monthly_payment) / Math.log(1 + monthly_interest)
# num_months.ceil.times do 
# 	upcoming_month = month.next_month
# 	month = upcoming_month

# 	if principal < monthly_payment
# 		puts "principal #{principal}"
# 		monthly_payment = principal
# 		puts "monthly payment #{monthly_payment}"
# 		updated_balance = principal - monthly_payment
# 	else
# 		puts "principal #{principal}"
# 		updated_balance = principal - monthly_payment
# 		puts "monthly payment #{monthly_payment}"
# 	end
# 	principal = updated_balance
# end

###################
# Count the pairs
###################
# ar = [10, 20, 20, 10, 10, 30, 50, 10, 20]
# pairs = {}
# count = 0

# ar.each do |i|
# 	if pairs[i] && pairs[i].odd?
# 		pairs[i] += 1
# 		count += 1
# 	else	
# 		pairs[i] = 1
# 	end
# end

####################
# Count the Valleys
####################
n = 8
s = "UDDDUDUUUUUDDDDDDUUUDUDUUD"

num = [0,-1,-2,-3,-2,-1,0]
mark_1 = nil
mark_2 = nil
valley = 0

num.each_with_index do |t, i|
	if t === 0 && mark_1 != 0 
		mark_1 = i.to_i 
	elsif
		mark_2 = i.to_i
	end
end
num[(mark_1..mark_2)].inject(:+) < 0 ? valley += 1 : mountain
p valley


# def countingValleys(n, s)
#     line = 0
#     valley = 0
#     letters = s.split("")

#     letters.each do |t|
#     	p t === "D" ? line -= 1 : line += 1
#     end

#     p valley
# end

# countingValleys(n, s)