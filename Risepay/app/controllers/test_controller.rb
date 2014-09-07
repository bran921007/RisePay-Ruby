#require_relative '../models/risepay.rb'


class TestController < ApplicationController
  def index
  	data ={}

        data['NameOnCard']= "Jhonny";
        data['CardNum']="5149612222222229";
        data['ExpDate']="1214";
        data['Amount']="10000";
        data['CVNum']="734";
        data['InvNum']="ABD41";
        data['Zip']="36124";
        data['Street']="Gran vio 25";
        data['Customer']="John Developer";
        data['TipAmt']=1;

  		@risepay = Risepays.new("JhonnDev","U0H464z4")
      

      	@result =  @risepay.sale(data)
  end
end
