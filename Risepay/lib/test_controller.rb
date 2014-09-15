require_relative 'risepays.rb'

class TestController

  attr_accessor :risepay, :data, :result, :msg

  def initialize
    @data ={}
    
    @data['NameOnCard']= "Jhonny";
    @data['CardNum']="5149612222222229";
    @data['ExpDate']="1214";
    @data['Amount']="22";
    @data['CVNum']="678";

    @risepay = Risepays.new("demo","demo")

    @result =''
    @msg = ''
    #Call your transaction type
    Sale(@data)

  end

  def result_msg
    @message
    if @result['Approved']
      @message = "Approved. Transaction ID = " + @result['PNRef'] +  "\n"  +    "AuthCode = " + @result['AuthCode']

    else
      @message =  "Declined " + @result['Message']

    end 

    return @message
  end


  def Sale(data)

    @result =  @risepay.sale(data)

    result_msg()

  end

  def Auth(data)

    @result =  @risepay.auth(data)

    result_msg()
  end  

  def Void(data)
    data["PNRef"] = "24323401"
    @result =  @risepay.void(data)

    result_msg()
  end  

  def Return(data)

    data["PNRef"] = "24323401"
    @result =  @risepay.returnTrans(data)

    result_msg()
  end  

  def Capture(data)
    data["PNRef"] = "24323401"
    @result =  @risepay.capture(data)

    result_msg()
  end

end

