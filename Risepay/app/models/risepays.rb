=begin
 Risepay API helper

 @category  API helper
 @package   Risepay
 @author    support@risepay.com
 @copyright Copyright (c) 2014
 @version   1.0

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
=end

require 'uri'
require 'net/http'
require 'rubygems'
require 'ostruct'
require 'date'
require 'time'
require 'active_support'
require 'singleton' 

class Risepays < ActiveRecord::Base

	attr_accessor :UserName, :Password, :url, :defFileds, :info, :RespMSG, :formData


	def initialize(user,pass)
		@UserName = user;
		@Password = pass;
		@defFileds = ['TransType', 'NameOnCard','CardNum','ExpDate','Amount','CVNum','InvNum',
                               'Zip','Street', 'MagData', 'Amount','PNRef'];
    
    	@formData = [];
    	@url ="https://gateway1.risepay.com/ws/transact.asmx/ProcessCreditCard"
    	@amountFields = ['Amount', 'TipAmt', 'TaxAmt'];
    	@@instance = nil;

	end 	

	def Risepays.getInstance
		@@instance
	end

	def getGatewayUrl()
		
		return @url 
	end

	def setGatewayUrl(url)
		@url = url
	end

	def getDefFileds

		return @defFileds
	end


	def stringStartsWith(haystack, needle)

		haystack.index(needle)=== 0
	end;

	def getInstance
		return @instance
	end

	def get_gateway_url
		self.url;
	end;

	def amountConvert(num)
		amount = '%.2f' % num
		return amount
	end;

	

	def sale(opt = null)
		if opt
			@formData = opt
		end

		@formData["TransType"]="SALE"

		return prepare()

	end


	def auth(opt = null)

	    if opt
			@formData = opt
		end

		@formData["TransType"]="AUTH"

		return prepare()

	end

	def returnTrans(opt = null)

		if opt
			@formData = opt
		end

		@formData["TransType"]="Return"

		return prepare()
	end
		

	def void(opt = null)

		if opt
			@formData = opt
		end

		@formData["TransType"]="VOID"

		return prepare()

	end

	def capture(opt = null)

		if opt
			@formData = opt
		end
		
		@formData["TransType"]="FORCE"

		return prepare()

	end

	def prepare()

		@data = {};
		@data["UserName"] = @UserName
		@data["Password"] = @Password
		@data["ExtData"] = ''

		#fix amounts
		@amountFields.each do |f|
			@amountFields[2] = ''
			if @formData[f]
				@formData[f] = amountConvert(@formData[f])
			end	
		end

		#Construct ExtData
		@formData.each do |f , value|
			if !((@defFileds).include? f)
				 
			 	 @data['ExtData']<< "<#{f}>#{value}</#{f}>";
				 @formData.delete(f)
			else
				@data[f] = value;
			
			end
		end

		# set defaults fields
		@defFileds.each do |f|
			if @data[f] == 	nil
			   	@data[f] = '';
			end 
		end

		return post(@data)
	end



	def post(opts)
	#data


	uri = URI.parse(@url)


    http = Net::HTTP.new(uri.host, uri.port)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = (uri.scheme == "https")
    request = Net::HTTP::Post.new(uri.request_uri)

    request.set_form_data(opts);
    #request.add_field("Content-Type", "application/x-www-form-urlencoded")

    response = http.request(request)
    xml= response.body
    session = Hash.from_xml(xml)
    resi = session['Response']
	return resi['RespMSG']

	end

end
