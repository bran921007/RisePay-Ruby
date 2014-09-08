#require_relative '../models/risepay.rb'


class TestController < ApplicationController
  def index
  	data ={}

        data['NameOnCard']= "Jhonny";
        data['CardNum']="5149612222222229";
        data['ExpDate']="1214";
        data['Amount']="15";
        data['CVNum']="678";
        data['InvNum']="ABC123";
        data['Zip']="33139";
        data['Street']="Gran vio 25";
        data['TipAmt']=1;

  		@risepay = Risepays.new("JhonnDev","U0H464z4")
      	

      	@result =  @risepay.sale(data)


      	def result_msg
      		@message
	      	if @result['Approved']
	      		@message = "Approved. Transaction ID = " + @result['PNRef'] +  "\n"  +    "AuthCode = " + @result['AuthCode']


	      	else
	      		@message =  "Declined " + @result['Message']

	      	end	

	      	return @message
	     end

	    @msn = result_msg

  end
end
