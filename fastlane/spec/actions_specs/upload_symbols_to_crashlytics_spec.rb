describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload_symbols_to_crashlytics" do
      before :each do
        allow(FastlaneCore::FastlaneFolder).to receive(:path).and_return(nil)
      end

      it "extracts zip files" do
        binary_path = './fastlane/spec/fixtures/screenshots/screenshot1.png'
        dsym_path = './fastlane/spec/fixtures/dSYM/Themoji.dSYM.zip'

        expect(Fastlane::Actions).to receive(:sh).with("unzip -qo #{File.expand_path(dsym_path).shellescape}")

        Fastlane::FastFile.new.parse("lane :test do
          upload_symbols_to_crashlytics(
            dsym_path: '#{dsym_path}',
            api_token: 'something123',
            binary_path: '#{binary_path}')
        end").runner.execute(:test)
      end

      it "uploads dSYM files" do
        binary_path = './spec/fixtures/screenshots/screenshot1.png'
        dsym_path = './spec/fixtures/dSYM/Themoji.dSYM'
        gsp_path = './spec/fixtures/plist/Info.plist'

        command = []
        command << File.expand_path(File.join("fastlane", binary_path)).shellescape
        command << "-a something123"
        command << "-gsp #{File.expand_path(File.join('fastlane', gsp_path)).shellescape}"
        command << "-p ios"
        command << File.expand_path(File.join("fastlane", dsym_path)).shellescape

        expect(Fastlane::Actions).to receive(:sh).with(command.join(" "), log: false)

        Fastlane::FastFile.new.parse("lane :test do
          upload_symbols_to_crashlytics(
            dsym_path: 'fastlane/#{dsym_path}',
            gsp_path: 'fastlane/#{gsp_path}',
            api_token: 'something123',
            binary_path: 'fastlane/#{binary_path}')
        end").runner.execute(:test)
      end

      it "raises exception if no api access is given" do
        binary_path = './spec/fixtures/screenshots/screenshot1.png'
        dsym_path = './spec/fixtures/dSYM/Themoji.dSYM'

        expect do
          result = Fastlane::FastFile.new.parse("lane :test do
            upload_symbols_to_crashlytics(
              dsym_path: 'fastlane/#{dsym_path}',
              binary_path: 'fastlane/#{binary_path}')
          end").runner.execute(:test)
        end.to raise_error(FastlaneCore::Interface::FastlaneError)
      end
    end
  end
end
