require 'tag_comparer'

describe 'tag_comparer' do

  it 'should compare simple versions' do
    TagComparer.get_latest('2', '1.5').should == '2'
    TagComparer.get_latest('1.5', '1.5.1').should == '1.5.1'
    TagComparer.get_latest('3.1', '4.0').should == '4.0'
    TagComparer.get_latest('1.0', '0.9').should == '1.0'
  end

  it 'should compare versions with multiple digits correctly' do
    TagComparer.get_latest('1.10', '1.9').should == '1.10'
    TagComparer.get_latest('1.5.41', '1.5.4').should == '1.5.41'
  end

  it 'should compare version that start with v' do
    TagComparer.get_latest('v1', 'v2').should == 'v2'
    TagComparer.get_latest('v1.6', 'v1.4').should == 'v1.6'
    TagComparer.get_latest('v1.3.1', 'v1.3').should == 'v1.3.1'
  end

  it 'should compare version with rc' do
    TagComparer.get_latest('v1.3.rc1', 'v1.3.rc2').should == 'v1.3.rc2'
    TagComparer.get_latest('v1.3.rc12', 'v1.3.rc1').should == 'v1.3.rc12'
  end

  it 'should compare versions with beta' do
    TagComparer.get_latest('v1.3.beta1', 'v1.3.beta2').should == 'v1.3.beta2'
    TagComparer.get_latest('v1.3.beta10', 'v1.3.beta9').should == 'v1.3.beta10'
    TagComparer.get_latest('v1.3.beta1', 'v1.3.rc1').should == 'v1.3.rc1'
  end

  it 'should compare an array of items' do
   TagComparer.get_latest(['v1.3.beta', 'v2.3.1','v2.5.rc2']).should == 'v2.5.rc2'
   TagComparer.get_latest(['v1.3.beta1', 'v1.3.rc1', 'v1.3.alpha1']) 
  end

end


