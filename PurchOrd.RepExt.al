reportextension 50101 "Purchase Order Ext" extends 1322
{
    dataset
    {
        add("Purchase Header")
        {
            column(AccountID; "Account ID") { }
            column(OrderDateTxt; FormatDateShort("Order Date")) { }
            column(FallbackCurrencyCode; "Currency Code") { }
            column(Purchaser_Code; "Purchaser Code") { }
            column(Expected_Receipt_Date; Format("Expected Receipt Date")) { }
            column(Document_Date; FormatDateShort("Document Date")) { }
        }

        add("Purchase Line")
        {
            column(ItemLineNo; ItemLineNo) { }
            column(ItemNoPrint; GetItemNoToPrint()) { }
            column(QtyPrint; GetQtyToPrint()) { }
            column(ExpectedReceiptDateTxt; FormatDateShort("Expected Receipt Date")) { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            column(DirUnitCost_Text; FormatCurrency("Direct Unit Cost")) { }
            column(LineAmt_Text; FormatCurrency("Line Amount")) { }
            column(DirUnitCost; FormatCurrency("Direct Unit Cost")) { }
            column(LineAmt; FormatCurrency("Line Amount")) { }
        }
    }

    local procedure GetItemNoToPrint(): Text[50]
    begin
        if "Purchase Line".Type = "Purchase Line".Type::Item then
            exit(Format("Purchase Line"."No."))
        else
            exit('');
    end;

    local procedure GetQtyToPrint(): Text
    var
        Qty: Decimal;
        IntegerPart: Decimal;
        QtyText: Text;
    begin
        if "Purchase Line".Type = "Purchase Line".Type::Item then begin
            Qty := "Purchase Line".Quantity;

            IntegerPart := Qty div 1;

            QtyText := Format(IntegerPart);
            QtyText := DelChr(QtyText, '=', ',');
            QtyText := ThousandSeparator(QtyText);

            exit(QtyText);
        end;

        exit('');
    end;

    // Helper function to insert commas manually
    local procedure ThousandSeparator(Input: Text): Text
    var
        ResultStr: Text;
        LenStr, Count, i : Integer;
    begin
        ResultStr := '';
        LenStr := StrLen(Input);
        Count := 0;

        for i := LenStr downto 1 do begin
            ResultStr := CopyStr(Input, i, 1) + ResultStr;
            Count += 1;
            if (Count mod 3 = 0) and (i > 1) then
                ResultStr := ',' + ResultStr;
        end;

        exit(ResultStr);
    end;

    local procedure FormatDateShort(InputDate: Date): Text
    var
        Day: Integer;
        Month: Integer;
        Year: Integer;
        DayText: Text;
    begin
        if InputDate = 0D then
            exit('');

        Day := Date2DMY(InputDate, 1);
        Month := Date2DMY(InputDate, 2);
        Year := Date2DMY(InputDate, 3);

        // Always 2 digits for day
        if Day < 10 then
            DayText := '0' + Format(Day)
        else
            DayText := Format(Day);

        exit(Format(Month) + '/' + DayText + '/' + Format(Year));
    end;

    local procedure FormatCurrency(Value: Decimal): Text
    var
        IsNegative: Boolean;
        DecimalCount: Integer;
        IntegerPart: Decimal;
        FractionPart: Decimal;
        IntegerText: Text;
        FractionText: Text;
        Multiplier: Decimal;
    begin
        if Value = 0 then
            exit('$0.00');

        if Value < 0 then begin
            IsNegative := true;
            Value := Abs(Value);
        end;

        DecimalCount := CountDecimals(Value);
        if DecimalCount < 2 then
            DecimalCount := 2;
        if DecimalCount > 5 then
            DecimalCount := 5;

        Multiplier := Power(10, DecimalCount);

        Value := Round(Value * Multiplier, 1) / Multiplier;

        IntegerPart := Value div 1;
        FractionPart := Round((Value - IntegerPart) * Multiplier, 1);

        // Clean integer part
        IntegerText := DelChr(Format(IntegerPart), '=', ',');
        IntegerText := ThousandSeparator(IntegerText);

        // Clean fraction part (IMPORTANT FIX)
        FractionText := DelChr(Format(FractionPart), '=', ',');
        while StrLen(FractionText) < DecimalCount do
            FractionText := '0' + FractionText;

        if IsNegative then
            exit('-$' + IntegerText + '.' + FractionText)
        else
            exit('$' + IntegerText + '.' + FractionText);
    end;

    local procedure ConvertIntegerToText(Value: Decimal): Text
    begin
        exit(DelChr(Format(Value), '=', ','));
    end;

    local procedure CountDecimals(Value: Decimal): Integer
    var
        TempValue: Decimal;
        Count: Integer;
    begin
        TempValue := Value;
        Count := 0;

        while (TempValue <> Round(TempValue, 1)) and (Count < 5) do begin
            TempValue := TempValue * 10;
            Count += 1;
        end;

        exit(Count);
    end;
}