describe('Create a new calendar', () => {
    it('Given I am authenticated as "admin" using "changeme"', () => {
        browser.url('/index.php');
        $('body*=Please Login').isExisting().should.to.be.true;
        $('#UserBox').setValue('admin');
        $('#PasswordBox').setValue('changeme');
        $('button=Login').click();
        $('body*=Welcome to').isExisting().should.to.be.true;
    });

    it('And  I am on "/v2/calendar"', () => {
        browser.url('/v2/calendar');
    });

    it('And I click the "#newCalendarButton" element', () => {
        $('#newCalendarButton').click();
    });

    it('Then I should see "New Calendar"', () => {
        browser.waitUntil(() => {
        return $('body*=New Calendar').isExisting()
        }, 3000, 'expected text to be different after 3s');
        $('body*=New Calendar').isExisting().should.to.be.true;
    });

    it('And I fill in "calendarName" with "Test Calendar"', () => {
        $('#calendarName').setValue('Test Calendar');
    });

    it('And I fill in "ForegroundColor" with "000000"', () => {
        $('#ForegroundColor').setValue('000000');
    });

    it('And I fill in "BackgroundColor" with "FFFFFF"', () => {
        $('#BackgroundColor').setValue('FFFFFF');
    });

    it('And I press "Save"', () => {
        $('button=Save').click();
    });

    it('And I wait for AJAX to finish', () => {
        browser.waitUntil(() => {
        return (typeof(jQuery)=="undefined" || (0 === jQuery.active && 0 === jQuery(':animated').length))
        }, 3000, 'expected text to be different after 3s');
    });

    it('Then I should see "Test Calendar"', () => {
        $('body*=Test Calendar').isExisting().should.to.be.true;
    });
});
