require 'rails_helper'

# あるクラスが依存しているクラスのnewを通過する引数を検査したい時のサンプル
# newはクラスメソッドなので、クラスメソッドをスタブするのどうやるんだっけ？というのがスタート

RSpec.describe User, type: :model do
  fixtures :users

  it 'newはクラスメソッドだからclass_doubleを使う？' do
    class_double(ExternalApi).as_stubbed_const

    # #<ClassDouble(ExternalApi) (anonymous)> received unexpected message :new with ({:greet=>"Good morning"})
    users(:morning_man).fetch_external_with_initial_value

    expect(ExternalApi).to have_received(:new).with(greet: "Good morning")
  end

  it 'ExternalApiのnewとfetchを補った後で、as_stubbed_constする' do
    class_double(ExternalApi, new: instance_double(ExternalApi, fetch: 'hello')).as_stubbed_const

    users(:morning_man).fetch_external_with_initial_value

    expect(ExternalApi).to have_received(:new).with(greet: "Good morning")
  end

  it '依存しているクラスのnewをスタブ化して、newの引数を検査する' do
    # allowを使うと特定のメソッドだけスタブ化できる。
    # さらにand_call_originalを使ってnewが元々の動きをすることで、
    # その後のfetchメソッドの動きにも影響を与えない。
    allow(ExternalApi).to receive(:new).and_call_original

    users(:morning_man).fetch_external_with_initial_value

    expect(ExternalApi).to have_received(:new).with(greet: "Good morning")
  end
end
