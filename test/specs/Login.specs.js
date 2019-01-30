describe('Login to a system', () => {
    it('Given I am on the homepage', () => {
        browser.url('/index.php');
    });

    it('Then I should see "Please Login"', () => {
        $('body*=Please Login').isExisting().should.to.be.true;
    });

    it('When I fill in "UserBox" with "admin"', () => {
        $('#UserBox').setValue('admin');
    });

    it('When I fill in "PasswordBox" with "changeme"', () => {
        $('#PasswordBox').setValue('changeme');
    });

    it('And I press "Login"', () => {
        $('button=Login').click();
    });

    it('Then I should see "Welcome to"', () => {
        $('body*=Welcome to').isExisting().should.to.be.true;
    });
});
