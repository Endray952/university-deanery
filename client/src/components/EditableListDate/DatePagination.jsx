import { Button, ButtonGroup } from "@mui/material";
import styled from "styled-components";

const Wrapper = styled.div`
    display: flex;
    justify-content: space-between;
    width: fit-content;
    margin: 0;
    padding: 0;
`;

const Element = styled.div`
    padding-left: 10px;
    height: 100%;
    width: fit-content;
    white-space: nowrap;
    text-align: center;
    font-size: 0.85em;
`;

/**
 * 
 * @param {Date} date 
 * @returns 
 */
export const toNormalDate = (date) => {
    let day = String(date.getDate());
    let month = String(date.getMonth() + 1);

    if (day.length === 1) {
        day = `0${day}`;
    }

    if (month.length === 1) {
        month = `0${month}`;
    }

    return `${day}.${month}.${String(date.getFullYear()).substring(2)}`;
};

/**
 * 
 * @param {Date} date 
 * @param {number} days 
 */
export const addDaysToDate = (date, days) => {
    const _date = new Date(date.getTime())
    return new Date(_date.setDate(_date.getDate() + days))
}

export const DatePagination = ({ page, onChange }) => {
    const currentDate = new Date(page);
    const weekText =
        toNormalDate(currentDate) +
        "-" +
        toNormalDate(
            addDaysToDate(currentDate, 7)
        );

    const turnBackward = () => {
        const currDate = new Date(page);
        const date = addDaysToDate(currDate, -7);
        onChange(`${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()}`);
    }

    const turnForward = () => {
        const currDate = new Date(page);
        const date = addDaysToDate(currDate, 7);
        onChange(`${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()}`);
    }

    return (
        <Wrapper>
            <ButtonGroup size="small">
                <Button onClick={turnBackward}>Предыдущая неделя</Button>
                <Button>{weekText}</Button>
                <Button onClick={turnForward}>Следующая неделя</Button>
            </ButtonGroup>
        </Wrapper>
    );
};
