local _, Addon = ...;

Addon.DICT = CreateFrame( 'Frame' );
Addon.DICT:RegisterEvent( 'ADDON_LOADED' );
Addon.DICT:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jVars' ) then

        --
        --  Get module dictionary
        --
        --  @return table
        Addon.DICT.GetDictionary = function( self )
            if( self.Dictionary ) then
                return self.Dictionary;
            end
            self.Dictionary = {};
            for i,Row in pairs( ConsoleGetAllCommands() ) do
                local CurrentValue,DefaultValue,AccountWide,PerCharacter,_,Secure,ReadOnly = C_CVar.GetCVarInfo( Row.command );
                local Scope;
                if( PerCharacter ) then
                    Scope = 'Character';
                elseif( AccountWide ) then
                    Scope = 'Account';
                elseif( ReadOnly ) then
                    Scope = 'Locked';
                else
                    Scope = 'Unknown';
                end
                local Key = string.lower( Row.command );
                self.Dictionary[ Key ] = {
                    DefaultValue    = DefaultValue,
                    DisplayText     = Row.command,
                    Secure          = Secure,
                    Key             = Key,
                    Scope           = Scope,
                    Description     = Row.help,
                    CurrentValue    = CurrentValue,
                };
            end
            -- Aggrend feedback: https://youtu.be/H69PDuEaxDc?t=654
            if( Addon:IsClassic() ) then
                if( tonumber( self.Dictionary[ string.lower( 'nameplateMaxDistance' ) ].CurrentValue ) >= 20 ) then
                    self.Dictionary[ string.lower( 'nameplateMaxDistance' ) ].CurrentValue = 20;
                end
            end
            return self.Dictionary;
        end

        Addon.DICT:UnregisterEvent( 'ADDON_LOADED' );
    end
end );