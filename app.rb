#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "pizzashop.db"}

class Product < ActiveRecord::Base
end

class Order < ActiveRecord::Base
end

get '/' do
	@products = Product.all
	erb :index
end

get '/about' do
	erb :about
end

get '/cart' do

	# Получаем список параметров и разбираем (parse) их

	@orders_input = params[:orders_input]
	@items = parse_orders_input @orders_input

	# Выводим сообщение о том, что корзина пуста

	if @items.length == 0
		return erb :cart_is_empty
	end

	# Выводим список продуктов в корзине

	@items.each do |item|
		# id, cnt
		item[0] = Product.find(item[0])
	end

	# Возвращаем представление по умолчанию

	erb :cart
end

# get '/place_order' do
# 	@order = Order.new
# 	erb :cart
# end

post '/place_order' do
	@order = Order.new params[:order]
	# @order = Order.create params[:order] // не нужно прописывать метод .save, тем самым объект создается сразу в бд
	if @order.save
		erb "Ваш заказ принят"
	else
		@error = @order.errors.full_messages.first
		erb :cart
	end
	erb :order_placed
end

get '/orders' do
	@orders = Order.all
	erb :orders
end
# post '/cart' do
# 	orders_input = params[:orders]
# 	erb "Hello1 #{orders_input}"
# end

def parse_orders_input orders_input

		s1 = orders_input.split(/,/)

		arr = []

		s1.each do |x|
			s2 = x.split(/\=/)

			s3 = s2[0].split(/_/)

			id = s3[1]
			cnt = s2[1]

			arr2 = [id, cnt]

			arr.push arr2	
		end

		return arr
end